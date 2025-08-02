#!/bin/bash

# Script to add @audit at the end of specified contract files

# Define the file mappings (filename -> actual path)
declare -A file_paths=(
    ["DexAggregatorWrapperWithPredicateProxy.sol"]=""
    ["TellerWithMultiAssetSupportPredicateProxy.sol"]=""
    ["YieldBlacklistRestrictions.sol"]="/home/teycir/Repos/plumecontracts202508/arc/src/restrictions/YieldBlacklistRestrictions.sol"
    ["WhitelistRestrictions.sol"]="/home/teycir/Repos/plumecontracts202508/arc/src/restrictions/WhitelistRestrictions.sol"
    ["RestrictionsRouter.sol"]="/home/teycir/Repos/plumecontracts202508/arc/src/restrictions/RestrictionsRouter.sol"
    ["RestrictionsFactory.sol"]="/home/teycir/Repos/plumecontracts202508/arc/src/restrictions/RestrictionsFactory.sol"
    ["RestrictionTypes.sol"]="/home/teycir/Repos/plumecontracts202508/arc/src/restrictions/RestrictionTypes.sol"
    ["ArcTokenPurchase.sol"]="/home/teycir/Repos/plumecontracts202508/arc/src/ArcTokenPurchase.sol"
    ["ArcTokenFactory.sol"]="/home/teycir/Repos/plumecontracts202508/arc/src/ArcTokenFactory.sol"
    ["ArcToken.sol"]="/home/teycir/Repos/plumecontracts202508/arc/src/ArcToken.sol"
    ["Spin.sol"]="/home/teycir/Repos/plumecontracts202508/plume/src/spin/Spin.sol"
    ["Raffle.sol"]="/home/teycir/Repos/plumecontracts202508/plume/src/spin/Raffle.sol"
    ["DateTime.sol"]="/home/teycir/Repos/plumecontracts202508/plume/src/spin/DateTime.sol"
    ["PlumeValidatorLogic.sol"]="/home/teycir/Repos/plumecontracts202508/plume/src/lib/PlumeValidatorLogic.sol"
    ["PlumeStakingStorage.sol"]="/home/teycir/Repos/plumecontracts202508/plume/src/lib/PlumeStakingStorage.sol"
    ["PlumeRoles.sol"]="/home/teycir/Repos/plumecontracts202508/plume/src/lib/PlumeRoles.sol"
    ["PlumeRewardLogic.sol"]="/home/teycir/Repos/plumecontracts202508/plume/src/lib/PlumeRewardLogic.sol"
    ["PlumeEvents.sol"]="/home/teycir/Repos/plumecontracts202508/plume/src/lib/PlumeEvents.sol"
    ["PlumeErrors.sol"]="/home/teycir/Repos/plumecontracts202508/plume/src/lib/PlumeErrors.sol"
    ["ValidatorFacet.sol"]="/home/teycir/Repos/plumecontracts202508/plume/src/facets/ValidatorFacet.sol"
    ["StakingFacet.sol"]="/home/teycir/Repos/plumecontracts202508/plume/src/facets/StakingFacet.sol"
    ["RewardsFacet.sol"]="/home/teycir/Repos/plumecontracts202508/plume/src/facets/RewardsFacet.sol"
    ["ManagementFacet.sol"]="/home/teycir/Repos/plumecontracts202508/plume/src/facets/ManagementFacet.sol"
    ["AccessControlFacet.sol"]="/home/teycir/Repos/plumecontracts202508/plume/src/facets/AccessControlFacet.sol"
    ["PlumeStakingRewardTreasury.sol"]="/home/teycir/Repos/plumecontracts202508/plume/src/PlumeStakingRewardTreasury.sol"
    ["PlumeStaking.sol"]="/home/teycir/Repos/plumecontracts202508/plume/src/PlumeStaking.sol"
    ["WPLUME.sol"]="/home/teycir/Repos/plumecontracts202508/misc/src/WPLUME.sol"
    ["Plume.Sol"]="/home/teycir/Repos/plumecontracts202508/misc/src/Plume.sol"
)

echo "Adding @audit comments to contract files..."
echo "=========================================="

processed=0
not_found=0

for filename in "${!file_paths[@]}"; do
    filepath="${file_paths[$filename]}"
    
    if [[ -z "$filepath" ]]; then
        echo "❌ $filename - File not found in repository"
        ((not_found++))
        continue
    fi
    
    if [[ ! -f "$filepath" ]]; then
        echo "❌ $filename - Path exists but file not found: $filepath"
        ((not_found++))
        continue
    fi
    
    # Check if @audit already exists at the end of the file
    if tail -1 "$filepath" | grep -q "@audit"; then
        echo "⚠️  $filename - @audit already exists"
        continue
    fi
    
    # Add @audit at the end of the file
    echo "" >> "$filepath"
    echo "// @audit" >> "$filepath"
    echo "✅ $filename - @audit added"
    ((processed++))
done

echo ""
echo "Summary:"
echo "- Files processed: $processed"
echo "- Files not found: $not_found"
echo "- Total files in list: ${#file_paths[@]}"