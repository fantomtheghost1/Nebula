// Fill out your copyright notice in the Description page of Project Settings.


#include "CargoComponent.h"
#include "Engine/AssetManager.h"
#include "Nebula/DataAssets/CraftingRecipeAsset.h"
#include "Nebula/Utils/NebulaLogging.h"

// Called when the game starts
void UCargoComponent::BeginPlay()
{
	Super::BeginPlay();
	
	if (MaxCargoSlots <= 0) FMessageLog("PIE").Error(FText::FromString("MaxCargoSlots must be greater than zero."));
	
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

void UCargoComponent::AddCargoItem(UCargoItemAsset* NewCargo, int Quantity)
{
	if (Cargo.Num() >= MaxCargoSlots) return;
	
	FCargoItemData NewCargoData;
	
	NewCargoData.ItemID = NewCargo->ItemID;
	NewCargoData.StackMax = NewCargo->StackMax;
	NewCargoData.Quantity = Quantity;
	NewCargoData.ItemAsset = NewCargo;
	NewCargoData.SalePrice = NewCargo->SalePrice;
	
	int32 Index = Cargo.IndexOfByKey(NewCargoData);
	if (Index != INDEX_NONE)
	{
		Cargo[Index].Quantity += Quantity;
	}
	else
	{
		Cargo.Add(NewCargoData);
	}
	CargoChanged.Broadcast();
}

void UCargoComponent::AddCargo(UCargoComponent* OtherCargo)
{
	if (Cargo.Num() >= MaxCargoSlots) return;
	
	for (FCargoItemData CargoData : OtherCargo->Cargo)
	{
		AddCargoItem(CargoData.ItemAsset, CargoData.Quantity);
	}
	CargoChanged.Broadcast();
}

void UCargoComponent::SubtractCargoItem(UCargoItemAsset* NewCargo, int Quantity)
{
	if (!NewCargo) return;

	int32 Index = Cargo.IndexOfByKey(FCargoItemData{NewCargo->ItemID});
	if (Index != INDEX_NONE)
	{
		Cargo[Index].Quantity -= Quantity;
		if (Cargo[Index].Quantity <= 0)
		{
			Cargo.RemoveAt(Index);
		}
		CargoChanged.Broadcast();
	}
	else
	{
		UE_LOG(LogBackend, Error, TEXT("Attempted to subtract cargo that doesn't exist! %s"), *NewCargo->ItemID.ToString());
	}
}


TArray<FCargoItemData> UCargoComponent::GetCargo()
{
	return Cargo;
}

UCargoItemAsset* UCargoComponent::GetCargoItemByID(FName ItemID)
{
	for (int i = 0; i < CargoItemAssets.Num(); i++)
	{
		if (CargoItemAssets[i]->ItemID == ItemID) return CargoItemAssets[i];
	}
	
	return nullptr;
}

int UCargoComponent::GetCargoQuantity(FName ItemID)
{
	for (int i = 0; i < Cargo.Num(); i++)
	{
		if (Cargo[i].ItemID == ItemID) return Cargo[i].Quantity;
	}
	
	return 0;
}

int UCargoComponent::GetMaxSlots()
{
	return MaxCargoSlots;
}

