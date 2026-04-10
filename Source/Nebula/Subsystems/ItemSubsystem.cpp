// Fill out your copyright notice in the Description page of Project Settings.


#include "ItemSubsystem.h"

#include "../DataAssets/CraftingRecipeAsset.h"
#include "Engine/AssetManager.h"
#include "Nebula/Utils/NebulaLogging.h"

void UItemSubsystem::Initialize(FSubsystemCollectionBase& Collection)
{
	Super::Initialize(Collection);
	
	TArray<FAssetData> TempCargoItems;
	UAssetManager& AM = UAssetManager::Get();
	AM.GetPrimaryAssetDataList(
		FPrimaryAssetType("CargoItem"),
		TempCargoItems
		);
	
	for (const FAssetData& Item : TempCargoItems)
	{
		UCargoItemAsset* ItemAsset = Cast<UCargoItemAsset>(Item.GetAsset());
		if (ItemAsset)
		{
			CargoItemAssets.Add(ItemAsset);
		}
	}
	UE_LOG(LogDataAsset, Warning, TEXT("Cargo Items Loaded: %d"), CargoItemAssets.Num());
}

TArray<UCargoItemAsset*> UItemSubsystem::GetItems() const
{
	return CargoItemAssets;
}

UCargoItemAsset* UItemSubsystem::GetItem(FName ItemName)
{
	for (int i = 0; i < CargoItemAssets.Num(); i++)
	{
		if (CargoItemAssets[i]->ItemID == ItemName) return CargoItemAssets[i];
	}
	
	return nullptr;
}