**THIS CHECKLIST IS NOT COMPLETE**. Use `--show-ignored-findings` to show all the results.
Summary
 - [arbitrary-send-eth](#arbitrary-send-eth) (3 results) (High)
 - [weak-prng](#weak-prng) (1 results) (High)
 - [controlled-delegatecall](#controlled-delegatecall) (2 results) (High)
 - [incorrect-exp](#incorrect-exp) (1 results) (High)
 - [unprotected-upgrade](#unprotected-upgrade) (2 results) (High)
 - [divide-before-multiply](#divide-before-multiply) (11 results) (Medium)
 - [incorrect-equality](#incorrect-equality) (8 results) (Medium)
 - [locked-ether](#locked-ether) (5 results) (Medium)
 - [uninitialized-local](#uninitialized-local) (10 results) (Medium)
 - [unused-return](#unused-return) (23 results) (Medium)
## arbitrary-send-eth
Impact: High
Confidence: Medium
 - [ ] ID-0
[Spin._safeTransferPlume(address,uint256)](plume/src/spin/Spin.sol#L579-L583) sends eth to arbitrary user
	Dangerous calls:
	- [(success,None) = _to.call{value: _amount}()](plume/src/spin/Spin.sol#L581)

plume/src/spin/Spin.sol#L579-L583


 - [ ] ID-1
[ManagementFacet.adminWithdraw(address,uint256,address)](plume/src/facets/ManagementFacet.sol#L134-L171) sends eth to arbitrary user
	Dangerous calls:
	- [(success,None) = address(recipient).call{value: amount}()](plume/src/facets/ManagementFacet.sol#L156)

plume/src/facets/ManagementFacet.sol#L134-L171


 - [ ] ID-2
[PlumeStakingRewardTreasury.distributeReward(address,uint256,address)](plume/src/PlumeStakingRewardTreasury.sol#L160-L199) sends eth to arbitrary user
	Dangerous calls:
	- [(success,None) = recipient.call{value: amount}()](plume/src/PlumeStakingRewardTreasury.sol#L179)

plume/src/PlumeStakingRewardTreasury.sol#L160-L199


## weak-prng
Impact: High
Confidence: Medium
 - [ ] ID-3
[Spin.determineReward(uint256,uint256)](plume/src/spin/Spin.sol#L278-L304) uses a weak PRNG: "[dayOfWeek = uint8(daysSinceStart % 7)](plume/src/spin/Spin.sol#L287)" 

plume/src/spin/Spin.sol#L278-L304


## controlled-delegatecall
Impact: High
Confidence: Medium
 - [ ] ID-4
[DiamondWritableInternal._initialize(address,bytes)](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/diamond/writable/DiamondWritableInternal.sol#L276-L295) uses delegatecall to a input-controlled function id
	- [(success,None) = target.delegatecall(data)](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/diamond/writable/DiamondWritableInternal.sol#L286)

plume/src/lib/vendor/solidstate-solidity/contracts/proxy/diamond/writable/DiamondWritableInternal.sol#L276-L295


 - [ ] ID-5
[ECDSAMultisigWalletInternal._executeCall(IECDSAMultisigWalletInternal.Parameters)](plume/src/lib/vendor/solidstate-solidity/contracts/multisig/ECDSAMultisigWalletInternal.sol#L89-L115) uses delegatecall to a input-controlled function id
	- [(success,returndata) = parameters.target.delegatecall(parameters.data)](plume/src/lib/vendor/solidstate-solidity/contracts/multisig/ECDSAMultisigWalletInternal.sol#L98-L100)

plume/src/lib/vendor/solidstate-solidity/contracts/multisig/ECDSAMultisigWalletInternal.sol#L89-L115


## incorrect-exp
Impact: High
Confidence: Medium
 - [ ] ID-6
[Math.mulDiv(uint256,uint256,uint256)](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L204-L275) has bitwise-xor operator ^ instead of the exponentiation operator **: 
	 - [inverse = (3 * denominator) ^ 2](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L257)

plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L204-L275


## unprotected-upgrade
Impact: High
Confidence: High
 - [ ] ID-7
[Raffle](plume/src/spin/Raffle.sol#L17-L428) is an upgradeable contract that does not protect its initialize functions: [Raffle.initialize(address,address)](plume/src/spin/Raffle.sol#L106-L118). Anyone can delete the contract with: [UUPSUpgradeable.upgradeToAndCall(address,bytes)](plume/lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol#L92-L95)
plume/src/spin/Raffle.sol#L17-L428


 - [ ] ID-8
[Spin](plume/src/spin/Spin.sol#L13-L597) is an upgradeable contract that does not protect its initialize functions: [Spin.initialize(address,address)](plume/src/spin/Spin.sol#L90-L135). Anyone can delete the contract with: [UUPSUpgradeable.upgradeToAndCall(address,bytes)](plume/lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol#L92-L95)
plume/src/spin/Spin.sol#L13-L597


## divide-before-multiply
Impact: Medium
Confidence: Medium
 - [ ] ID-9
[Math.mulDiv(uint256,uint256,uint256)](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L204-L275) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L242)
	- [inverse *= 2 - denominator * inverse](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L265)

plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L204-L275


 - [ ] ID-10
[Math.mulDiv(uint256,uint256,uint256)](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L204-L275) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L242)
	- [inverse *= 2 - denominator * inverse](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L264)

plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L204-L275


 - [ ] ID-11
[Math.invMod(uint256,uint256)](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L315-L361) performs a multiplication on the result of a division:
	- [quotient = gcd / remainder](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L337)
	- [(gcd,remainder) = (remainder,gcd - remainder * quotient)](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L339-L346)

plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L315-L361


 - [ ] ID-12
[Math.mulDiv(uint256,uint256,uint256)](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L204-L275) performs a multiplication on the result of a division:
	- [low = low / twos](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L245)
	- [result = low * inverse](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L272)

plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L204-L275


 - [ ] ID-13
[PlumeRewardLogic.updateRewardPerTokenForValidator(PlumeStakingStorage.Layout,address,uint16)](plume/src/lib/PlumeRewardLogic.sol#L135-L197) performs a multiplication on the result of a division:
	- [grossRewardForValidatorThisSegment = (totalStaked * rewardPerTokenIncrease) / PlumeStakingStorage.REWARD_PRECISION](plume/src/lib/PlumeRewardLogic.sol#L181-L182)
	- [commissionDeltaForValidator = (grossRewardForValidatorThisSegment * commissionRateForSegment) / PlumeStakingStorage.REWARD_PRECISION](plume/src/lib/PlumeRewardLogic.sol#L185-L187)

plume/src/lib/PlumeRewardLogic.sol#L135-L197


 - [ ] ID-14
[Math.mulDiv(uint256,uint256,uint256)](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L204-L275) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L242)
	- [inverse *= 2 - denominator * inverse](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L263)

plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L204-L275


 - [ ] ID-15
[Math.mulDiv(uint256,uint256,uint256)](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L204-L275) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L242)
	- [inverse *= 2 - denominator * inverse](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L266)

plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L204-L275


 - [ ] ID-16
[Math.mulDiv(uint256,uint256,uint256)](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L204-L275) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L242)
	- [inverse *= 2 - denominator * inverse](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L261)

plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L204-L275


 - [ ] ID-17
[Math.mulDiv(uint256,uint256,uint256)](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L204-L275) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L242)
	- [inverse *= 2 - denominator * inverse](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L262)

plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L204-L275


 - [ ] ID-18
[PlumeRewardLogic._calculateRewardsCore(PlumeStakingStorage.Layout,address,uint16,address,uint256,uint256)](plume/src/lib/PlumeRewardLogic.sol#L212-L360) performs a multiplication on the result of a division:
	- [grossRewardForSegment = (userStakedAmount * rewardPerTokenDeltaForUserInSegment) / PlumeStakingStorage.REWARD_PRECISION](plume/src/lib/PlumeRewardLogic.sol#L340-L341)
	- [commissionForThisSegment = _ceilDiv(grossRewardForSegment * effectiveCommissionRate,PlumeStakingStorage.REWARD_PRECISION)](plume/src/lib/PlumeRewardLogic.sol#L347-L348)

plume/src/lib/PlumeRewardLogic.sol#L212-L360


 - [ ] ID-19
[Math.mulDiv(uint256,uint256,uint256)](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L204-L275) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L242)
	- [inverse = (3 * denominator) ^ 2](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L257)

plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L204-L275


## incorrect-equality
Impact: Medium
Confidence: High
 - [ ] ID-20
[Spin.isSameDay(uint16,uint8,uint8,uint16,uint8,uint8)](plume/src/spin/Spin.sol#L368-L377) uses a dangerous strict equality:
	- [(year1 == year2 && month1 == month2 && day1 == day2)](plume/src/spin/Spin.sol#L376)

plume/src/spin/Spin.sol#L368-L377


 - [ ] ID-21
[Spin._computeStreak(address,uint256,bool)](plume/src/spin/Spin.sol#L307-L325) uses a dangerous strict equality:
	- [today == lastDaySpun](plume/src/spin/Spin.sol#L318)

plume/src/spin/Spin.sol#L307-L325


 - [ ] ID-22
[PlumeRewardLogic.createRewardRateCheckpoint(PlumeStakingStorage.Layout,address,uint16,uint256)](plume/src/lib/PlumeRewardLogic.sol#L715-L748) uses a dangerous strict equality:
	- [len > 0 && checkpoints[len - 1].timestamp == block.timestamp](plume/src/lib/PlumeRewardLogic.sol#L735)

plume/src/lib/PlumeRewardLogic.sol#L715-L748


 - [ ] ID-23
[RewardsFacet.addRewardToken(address,uint256,uint256)](plume/src/facets/RewardsFacet.sol#L153-L202) uses a dangerous strict equality:
	- [$.tokenRemovalTimestamps[token] == block.timestamp](plume/src/facets/RewardsFacet.sol#L170)

plume/src/facets/RewardsFacet.sol#L153-L202


 - [ ] ID-24
[Spin._computeStreak(address,uint256,bool)](plume/src/spin/Spin.sol#L307-L325) uses a dangerous strict equality:
	- [today == lastDaySpun + 1](plume/src/spin/Spin.sol#L321)

plume/src/spin/Spin.sol#L307-L325


 - [ ] ID-25
[PlumeRewardLogic.getDistinctTimestamps(PlumeStakingStorage.Layout,uint16,address,uint256,uint256)](plume/src/lib/PlumeRewardLogic.sol#L440-L537) uses a dangerous strict equality:
	- [periodStart == periodEnd](plume/src/lib/PlumeRewardLogic.sol#L459)

plume/src/lib/PlumeRewardLogic.sol#L440-L537


 - [ ] ID-26
[Spin.handleRandomness(uint256,uint256[])](plume/src/spin/Spin.sol#L207-L265) uses a dangerous strict equality:
	- [currentWeek == lastJackpotClaimWeek](plume/src/spin/Spin.sol#L227)

plume/src/spin/Spin.sol#L207-L265


 - [ ] ID-27
[PlumeRewardLogic.createCommissionRateCheckpoint(PlumeStakingStorage.Layout,uint16,uint256)](plume/src/lib/PlumeRewardLogic.sol#L757-L786) uses a dangerous strict equality:
	- [len > 0 && checkpoints[len - 1].timestamp == block.timestamp](plume/src/lib/PlumeRewardLogic.sol#L773)

plume/src/lib/PlumeRewardLogic.sol#L757-L786


## locked-ether
Impact: Medium
Confidence: High
 - [ ] ID-28
Contract locking ether found:
	Contract [ManagedProxyMock](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/managed/ManagedProxyMock.sol#L7-L33) has payable functions:
	 - [Proxy.fallback()](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/Proxy.sol#L19-L45)
	 - [IProxy.fallback()](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/IProxy.sol#L8)
	 - [ManagedProxyMock.receive()](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/managed/ManagedProxyMock.sol#L32)
	But does not have a function to withdraw the ether

plume/src/lib/vendor/solidstate-solidity/contracts/proxy/managed/ManagedProxyMock.sol#L7-L33


 - [ ] ID-29
Contract locking ether found:
	Contract [UpgradeableProxyOwnableMock](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/upgradeable/UpgradeableProxyOwnableMock.sol#L7-L17) has payable functions:
	 - [Proxy.fallback()](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/Proxy.sol#L19-L45)
	 - [IProxy.fallback()](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/IProxy.sol#L8)
	 - [UpgradeableProxyOwnableMock.receive()](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/upgradeable/UpgradeableProxyOwnableMock.sol#L16)
	But does not have a function to withdraw the ether

plume/src/lib/vendor/solidstate-solidity/contracts/proxy/upgradeable/UpgradeableProxyOwnableMock.sol#L7-L17


 - [ ] ID-30
Contract locking ether found:
	Contract [ManagedProxyOwnableMock](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/managed/ManagedProxyOwnableMock.sol#L7-L35) has payable functions:
	 - [Proxy.fallback()](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/Proxy.sol#L19-L45)
	 - [IProxy.fallback()](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/IProxy.sol#L8)
	 - [ManagedProxyOwnableMock.receive()](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/managed/ManagedProxyOwnableMock.sol#L34)
	But does not have a function to withdraw the ether

plume/src/lib/vendor/solidstate-solidity/contracts/proxy/managed/ManagedProxyOwnableMock.sol#L7-L35


 - [ ] ID-31
Contract locking ether found:
	Contract [ProxyMock](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/ProxyMock.sol#L7-L17) has payable functions:
	 - [Proxy.fallback()](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/Proxy.sol#L19-L45)
	 - [IProxy.fallback()](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/IProxy.sol#L8)
	But does not have a function to withdraw the ether

plume/src/lib/vendor/solidstate-solidity/contracts/proxy/ProxyMock.sol#L7-L17


 - [ ] ID-32
Contract locking ether found:
	Contract [UpgradeableProxyMock](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/upgradeable/UpgradeableProxyMock.sol#L7-L24) has payable functions:
	 - [Proxy.fallback()](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/Proxy.sol#L19-L45)
	 - [IProxy.fallback()](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/IProxy.sol#L8)
	 - [UpgradeableProxyMock.receive()](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/upgradeable/UpgradeableProxyMock.sol#L23)
	But does not have a function to withdraw the ether

plume/src/lib/vendor/solidstate-solidity/contracts/proxy/upgradeable/UpgradeableProxyMock.sol#L7-L24


## uninitialized-local
Impact: Medium
Confidence: Medium
 - [ ] ID-33
[UintUtils.toOctString(uint256).length](plume/src/lib/vendor/solidstate-solidity/contracts/utils/UintUtils.sol#L159) is a local variable never initialized

plume/src/lib/vendor/solidstate-solidity/contracts/utils/UintUtils.sol#L159


 - [ ] ID-34
[DiamondWritableInternal._diamondCut(IERC2535DiamondCutInternal.FacetCut[],address,bytes).slug](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/diamond/writable/DiamondWritableInternal.sol#L36) is a local variable never initialized

plume/src/lib/vendor/solidstate-solidity/contracts/proxy/diamond/writable/DiamondWritableInternal.sol#L36


 - [ ] ID-35
[IncrementalMerkleTree.pop(IncrementalMerkleTree.Tree).row](plume/src/lib/vendor/solidstate-solidity/contracts/data/IncrementalMerkleTree.sol#L102) is a local variable never initialized

plume/src/lib/vendor/solidstate-solidity/contracts/data/IncrementalMerkleTree.sol#L102


 - [ ] ID-36
[UintUtils.toHexString(uint256).length](plume/src/lib/vendor/solidstate-solidity/contracts/utils/UintUtils.sol#L236) is a local variable never initialized

plume/src/lib/vendor/solidstate-solidity/contracts/utils/UintUtils.sol#L236


 - [ ] ID-37
[SolidStateDiamond.constructor().selectorIndex](plume/src/lib/vendor/solidstate-solidity/contracts/proxy/diamond/SolidStateDiamond.sol#L32) is a local variable never initialized

plume/src/lib/vendor/solidstate-solidity/contracts/proxy/diamond/SolidStateDiamond.sol#L32


 - [ ] ID-38
[UintUtils.toString(uint256,uint256).length](plume/src/lib/vendor/solidstate-solidity/contracts/utils/UintUtils.sol#L40) is a local variable never initialized

plume/src/lib/vendor/solidstate-solidity/contracts/utils/UintUtils.sol#L40


 - [ ] ID-39
[UintUtils.toBinString(uint256).length](plume/src/lib/vendor/solidstate-solidity/contracts/utils/UintUtils.sol#L107) is a local variable never initialized

plume/src/lib/vendor/solidstate-solidity/contracts/utils/UintUtils.sol#L107


 - [ ] ID-40
[ECDSAMultisigWalletInternal._verifySignatures(bytes,IECDSAMultisigWalletInternal.Signature[]).signerBitmap](plume/src/lib/vendor/solidstate-solidity/contracts/multisig/ECDSAMultisigWalletInternal.sol#L133) is a local variable never initialized

plume/src/lib/vendor/solidstate-solidity/contracts/multisig/ECDSAMultisigWalletInternal.sol#L133


 - [ ] ID-41
[Raffle.handleWinnerSelection(uint256,uint256[]).winnerAddress](plume/src/spin/Raffle.sol#L251) is a local variable never initialized

plume/src/spin/Raffle.sol#L251


 - [ ] ID-42
[IncrementalMerkleTree.push(IncrementalMerkleTree.Tree,bytes32).row](plume/src/lib/vendor/solidstate-solidity/contracts/data/IncrementalMerkleTree.sol#L74) is a local variable never initialized

plume/src/lib/vendor/solidstate-solidity/contracts/data/IncrementalMerkleTree.sol#L74


## unused-return
Impact: Medium
Confidence: Medium
 - [ ] ID-43
[ERC1155EnumerableInternal._beforeTokenTransfer(address,address,address,uint256[],uint256[],bytes)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC1155/enumerable/ERC1155EnumerableInternal.sol#L84-L128) ignores return value by [tokenAccounts[id].add(to)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC1155/enumerable/ERC1155EnumerableInternal.sol#L118)

plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC1155/enumerable/ERC1155EnumerableInternal.sol#L84-L128


 - [ ] ID-44
[ERC721BaseInternal._transfer(address,address,uint256)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/base/ERC721BaseInternal.sol#L109-L130) ignores return value by [l.tokenOwners.set(tokenId,to)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/base/ERC721BaseInternal.sol#L125)

plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/base/ERC721BaseInternal.sol#L109-L130


 - [ ] ID-45
[AccessControlInternal._revokeRole(bytes32,address)](plume/src/lib/vendor/solidstate-solidity/contracts/access/access_control/AccessControlInternal.sol#L104-L107) ignores return value by [AccessControlStorage.layout().roles[role].members.remove(account)](plume/src/lib/vendor/solidstate-solidity/contracts/access/access_control/AccessControlInternal.sol#L105)

plume/src/lib/vendor/solidstate-solidity/contracts/access/access_control/AccessControlInternal.sol#L104-L107


 - [ ] ID-46
[ERC721BaseInternal._burn(uint256)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/base/ERC721BaseInternal.sol#L93-L107) ignores return value by [l.holderTokens[owner].remove(tokenId)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/base/ERC721BaseInternal.sol#L100)

plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/base/ERC721BaseInternal.sol#L93-L107


 - [ ] ID-47
[ERC1155EnumerableInternal._beforeTokenTransfer(address,address,address,uint256[],uint256[],bytes)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC1155/enumerable/ERC1155EnumerableInternal.sol#L84-L128) ignores return value by [toTokens.add(id)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC1155/enumerable/ERC1155EnumerableInternal.sol#L119)

plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC1155/enumerable/ERC1155EnumerableInternal.sol#L84-L128


 - [ ] ID-48
[ERC721BaseInternal._mint(address,uint256)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/base/ERC721BaseInternal.sol#L65-L77) ignores return value by [l.tokenOwners.set(tokenId,to)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/base/ERC721BaseInternal.sol#L74)

plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/base/ERC721BaseInternal.sol#L65-L77


 - [ ] ID-49
[ERC721BaseInternal._mint(address,uint256)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/base/ERC721BaseInternal.sol#L65-L77) ignores return value by [l.holderTokens[to].add(tokenId)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/base/ERC721BaseInternal.sol#L73)

plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/base/ERC721BaseInternal.sol#L65-L77


 - [ ] ID-50
[ERC721BaseInternal._burn(uint256)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/base/ERC721BaseInternal.sol#L93-L107) ignores return value by [l.tokenOwners.remove(tokenId)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/base/ERC721BaseInternal.sol#L101)

plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/base/ERC721BaseInternal.sol#L93-L107


 - [ ] ID-51
[ERC1155EnumerableInternal._beforeTokenTransfer(address,address,address,uint256[],uint256[],bytes)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC1155/enumerable/ERC1155EnumerableInternal.sol#L84-L128) ignores return value by [tokenAccounts[id].remove(from)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC1155/enumerable/ERC1155EnumerableInternal.sol#L111)

plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC1155/enumerable/ERC1155EnumerableInternal.sol#L84-L128


 - [ ] ID-52
[EnumerableMapAddressToAddressMock.at(uint256)](plume/src/lib/vendor/solidstate-solidity/contracts/data/EnumerableMapAddressToAddressMock.sol#L12-L14) ignores return value by [map.at(index)](plume/src/lib/vendor/solidstate-solidity/contracts/data/EnumerableMapAddressToAddressMock.sol#L13)

plume/src/lib/vendor/solidstate-solidity/contracts/data/EnumerableMapAddressToAddressMock.sol#L12-L14


 - [ ] ID-53
[ERC1967Utils.upgradeBeaconToAndCall(address,bytes)](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Utils.sol#L157-L166) ignores return value by [Address.functionDelegateCall(IBeacon(newBeacon).implementation(),data)](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Utils.sol#L162)

plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Utils.sol#L157-L166


 - [ ] ID-54
[EnumerableMapUintToAddressMock.at(uint256)](plume/src/lib/vendor/solidstate-solidity/contracts/data/EnumerableMapUintToAddressMock.sol#L12-L14) ignores return value by [map.at(index)](plume/src/lib/vendor/solidstate-solidity/contracts/data/EnumerableMapUintToAddressMock.sol#L13)

plume/src/lib/vendor/solidstate-solidity/contracts/data/EnumerableMapUintToAddressMock.sol#L12-L14


 - [ ] ID-55
[ERC721BaseInternal._transfer(address,address,uint256)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/base/ERC721BaseInternal.sol#L109-L130) ignores return value by [l.holderTokens[from].remove(tokenId)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/base/ERC721BaseInternal.sol#L123)

plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/base/ERC721BaseInternal.sol#L109-L130


 - [ ] ID-56
[Raffle.spendRaffle(uint256,uint256)](plume/src/spin/Raffle.sol#L189-L211) ignores return value by [(None,None,None,None,userRaffleTickets,None,None) = spinContract.getUserData(msg.sender)](plume/src/spin/Raffle.sol#L193)

plume/src/spin/Raffle.sol#L189-L211


 - [ ] ID-57
[RewardsFacet._earned(address,address,uint16)](plume/src/facets/RewardsFacet.sol#L100-L112) ignores return value by [(userRewardDelta,None,None) = PlumeRewardLogic.calculateRewardsWithCheckpoints($,user,validatorId,token,userStakedAmount)](plume/src/facets/RewardsFacet.sol#L107-L108)

plume/src/facets/RewardsFacet.sol#L100-L112


 - [ ] ID-58
[AccessControlInternal._grantRole(bytes32,address)](plume/src/lib/vendor/solidstate-solidity/contracts/access/access_control/AccessControlInternal.sol#L94-L97) ignores return value by [AccessControlStorage.layout().roles[role].members.add(account)](plume/src/lib/vendor/solidstate-solidity/contracts/access/access_control/AccessControlInternal.sol#L95)

plume/src/lib/vendor/solidstate-solidity/contracts/access/access_control/AccessControlInternal.sol#L94-L97


 - [ ] ID-59
[ERC721BaseInternal._transfer(address,address,uint256)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/base/ERC721BaseInternal.sol#L109-L130) ignores return value by [l.holderTokens[to].add(tokenId)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/base/ERC721BaseInternal.sol#L124)

plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/base/ERC721BaseInternal.sol#L109-L130


 - [ ] ID-60
[ERC1155EnumerableInternal._beforeTokenTransfer(address,address,address,uint256[],uint256[],bytes)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC1155/enumerable/ERC1155EnumerableInternal.sol#L84-L128) ignores return value by [fromTokens.remove(id)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC1155/enumerable/ERC1155EnumerableInternal.sol#L112)

plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC1155/enumerable/ERC1155EnumerableInternal.sol#L84-L128


 - [ ] ID-61
[RewardsFacet._earnedView(address,address,uint16)](plume/src/facets/RewardsFacet.sol#L604-L617) ignores return value by [(userRewardDelta,None,None) = PlumeRewardLogic.calculateRewardsWithCheckpointsView($,user,validatorId,token,userStakedAmount)](plume/src/facets/RewardsFacet.sol#L612-L613)

plume/src/facets/RewardsFacet.sol#L604-L617


 - [ ] ID-62
[ERC1967Utils.upgradeToAndCall(address,bytes)](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Utils.sol#L67-L76) ignores return value by [Address.functionDelegateCall(newImplementation,data)](plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Utils.sol#L72)

plume/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Utils.sol#L67-L76


 - [ ] ID-63
[RewardsFacet.getPendingRewardForValidator(address,uint16,address)](plume/src/facets/RewardsFacet.sol#L821-L837) ignores return value by [(userRewardDelta,None,None) = PlumeRewardLogic.calculateRewardsWithCheckpoints($,user,validatorId,token,userStakedAmount)](plume/src/facets/RewardsFacet.sol#L833-L834)

plume/src/facets/RewardsFacet.sol#L821-L837


 - [ ] ID-64
[ERC721EnumerableInternal._tokenByIndex(uint256)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/enumerable/ERC721EnumerableInternal.sol#L33-L37) ignores return value by [(tokenId,None) = ERC721BaseStorage.layout().tokenOwners.at(index)](plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/enumerable/ERC721EnumerableInternal.sol#L36)

plume/src/lib/vendor/solidstate-solidity/contracts/token/ERC721/enumerable/ERC721EnumerableInternal.sol#L33-L37


 - [ ] ID-65
[RewardsFacet._validateTokenForClaim(address,address)](plume/src/facets/RewardsFacet.sol#L397-L434) ignores return value by [(userRewardDelta,None,None) = PlumeRewardLogic.calculateRewardsWithCheckpointsView($,user,validatorId,token,userStakedAmount)](plume/src/facets/RewardsFacet.sol#L420-L422)

plume/src/facets/RewardsFacet.sol#L397-L434
