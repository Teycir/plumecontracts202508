### Consolidated Findings Table

| # | Contract | Function / Scope | Issue Type | Severity | Ref. Line(s) | Short Description | Confirmed? | Notes / Suggested Fix |
|---|----------|------------------|------------|----------|--------------|-------------------|------------|-----------------------|
| 1 | **Spin.sol** | `initialize()` | Oracle-manipulation surface | Critical | 90 | Grants **SUPRA_ROLE** to arbitrary `supraRouterAddress` without validation | ✅ Yes | Hard-code/trust-registry router or make address immutable |
| 2 | **Spin.sol** | `canSpin()` modifier | Access-control bypass | Critical | ~116 | Whitelisted users skip daily-limit checks via early `return` | ✅ Yes | Remove early return or give whitelist its own capped path |
| 3 | **Spin.sol** | `_safeTransferPlume()` | Wrong-asset transfer | Critical | 581 | Sends native ETH instead of PLUME ERC-20 | ✅ Yes | Replace with `IERC20(PLUME).safeTransfer` |
| 4 | **Spin.sol** | `handleRandomness()` | Weak access control | High | 207 | Any **SUPRA_ROLE** address can dictate outcomes | ✅ Yes | Add nonce/source validation, multi-sig oracle |
| 5 | **Spin.sol** | `determineReward()` | Weak PRNG fallback | High | ~287 | Uses predictable `daysSinceStart % 7` path | ⚠️ Partial | Acceptable only if VRF is un-tampered; otherwise refactor |
| 6 | **Raffle.sol** | `initialize()` | Unprotected upgrade | High | 106 | `initialize()` callable on proxy repeatedly | ✅ Yes | Add `onlyProxy`, `initializer` guard or restrict caller |
| 7 | **Raffle.sol** | `handleWinnerSelection()` | Oracle manipulation | High | 238 | **SUPRA_ROLE** fully controls winners | ✅ Yes | Same mitigation as Spin oracle |
| 8 | **ManagementFacet.sol** | `adminWithdraw()` | Arbitrary ETH send | High | 156 | `TIMELOCK_ROLE` can withdraw ETH/tokens anywhere | ✅ Yes | Secure role with timelock / multisig |
| 9 | **ManagementFacet.sol** | `pruneCommissionCheckpoints()` | Data corruption | High | 305 | Admin can delete all checkpoints → reward freeze | ✅ Yes | Enforce min-retain & safety checks |
|10 | **StakingFacet.sol** | `withdraw()` | External-call vulnerability | High | 416 | External call before state update; no re-entrancy guard | ✅ Yes | Add `nonReentrant`; update state first |
|11 | **PlumeStakingRewardTreasury.sol** | `distributeReward()` | Arbitrary ETH send | High | 179 | `DISTRIBUTOR_ROLE` can mis-route funds | ✅ Yes | Restrict role; consider pull model |
|12 | **RewardsFacet.sol** | Assembly blocks | Storage manipulation | High | 75 / 85 | Direct diamond-storage writes risk collisions | ⚠️ Partial | Review slot layout; add comments & tests |
|13 | **PlumeRewardLogic.sol** | `updateRewardPerTokenForValidator()` | Math precision loss | Medium | 181-187 | Divide before multiply truncates reward | ✅ Yes | Use `Math.mulDiv` or reorder math |
|14 | **PlumeRewardLogic.sol** | Assembly (view) | Direct storage access | Medium | ~533 | Low-level access not located in snippet | ⚠️ Partial | Verify intent; document or remove |

*Legend*  
✅ Confirmed • ⚠️ Partially-confirmed / needs deeper review