// Fill out your copyright notice in the Description page of Project Settings.


#include "CargoComponent.h"
#include "Engine/AssetManager.h"
#include "Nebula/DataAssets/CraftingRecipeAsset.h"
#include "Nebula/Utils/NebulaLogging.h"

// Called when the game starts
void UCargoComponent::BeginPlay()
{
	Super::BeginPlay();
	
	if (MaxWeight <= 0) FMessageLog("PIE").Error(FText::FromString("MaxWeight must be greater than zero."));
}

void UCargoComponent::AddCargoItem(UCargoItemAsset* NewCargo, float Weight)
{
	if (GetWeight() >= MaxWeight) return;
	FCargoItemData NewCargoData;
	
	NewCargoData.ItemID = NewCargo->ItemID;
	NewCargoData.Weight = Weight;
	NewCargoData.ItemAsset = NewCargo;
	NewCargoData.SalePrice = NewCargo->SalePrice;
	
	int32 Index = Cargo.IndexOfByKey(NewCargoData);
	if (Index != INDEX_NONE)
	{
		Cargo[Index].Weight += Weight;
	}
	else
	{
		Cargo.Add(NewCargoData);
	}
	CargoChanged.Broadcast();
}

void UCargoComponent::AddCargo(UCargoComponent* OtherCargo)
{
	if (GetWeight() >= MaxWeight) return;
	
	for (FCargoItemData CargoData : OtherCargo->Cargo)
	{
		AddCargoItem(CargoData.ItemAsset, CargoData.Weight);
	}
	CargoChanged.Broadcast();
}

void UCargoComponent::SubtractCargoItem(UCargoItemAsset* NewCargo, int Quantity)
{
	if (!NewCargo) return;

	int32 Index = Cargo.IndexOfByKey(FCargoItemData{NewCargo->ItemID});
	if (Index != INDEX_NONE)
	{
		Cargo[Index].Weight -= Quantity;
		if (Cargo[Index].Weight <= 0)
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

void UCargoComponent::RemoveCargo()
{
	Cargo.Empty();
}

TArray<FCargoItemData> UCargoComponent::GetCargo()
{
	return Cargo;
}

int UCargoComponent::GetCargoWeight(FName ItemID)
{
	for (int i = 0; i < Cargo.Num(); i++)
	{
		UE_LOG(LogCargo, Warning, TEXT("Does %s == %s"), *Cargo[i].ItemID.ToString(), *ItemID.ToString());
		UE_LOG(LogCargo, Warning, TEXT("Cargo Item Quantity: %i"), Cargo[i].Weight);
		if (Cargo[i].ItemID == ItemID) return Cargo[i].Weight;
	}
	
	return 0;
}

float UCargoComponent::GetWeight()
{
	float TempWeight = 0.0f;
	for (FCargoItemData CargoData : Cargo)
	{
		TempWeight += CargoData.Weight;
	}
	
	return TempWeight;
}

float UCargoComponent::GetMaxWeight()
{
	return MaxWeight;
}

