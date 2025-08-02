// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IERC4626 } from "@openzeppelin/contracts/interfaces/IERC4626.sol";

interface IComponentToken is IERC4626 {
    function requestDeposit(uint256 assets, address controller, address owner) external returns (uint256 requestId);
    function requestRedeem(uint256 shares, address controller, address owner) external returns (uint256 requestId);
    function deposit(uint256 assets, address receiver, address controller) external returns (uint256 shares);
    function redeem(uint256 shares, address receiver, address controller) external returns (uint256 assets);
    function assetsOf(address owner) external view returns (uint256 assets);
    function pendingDepositRequest(uint256 requestId, address controller) external view returns (uint256 assets);
    function claimableDepositRequest(uint256 requestId, address controller) external view returns (uint256 assets);
    function pendingRedeemRequest(uint256 requestId, address controller) external view returns (uint256 shares);
    function claimableRedeemRequest(uint256 requestId, address controller) external view returns (uint256 shares);
}