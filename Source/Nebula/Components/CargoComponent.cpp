// Fill out your copyright notice in the Description page of Project Settings.


#include "CargoComponent.h"

// Called when the game starts
void UCargoComponent::BeginPlay()
{
	Super::BeginPlay();
	
	if (MaxCargoSlots <= 0) FMessageLog("PIE").Error(FText::FromString("MaxCargoSlots must be greater than zero."));
}

void UCargoComponent::AddCargoItem(UCargoItemAsset* NewCargo, int Quantity)
{
	if (Cargo.Num() >= MaxCargoSlots) return;
	
	FCargoItemData NewCargoData;
	
	NewCargoData.ItemID = NewCargo->ItemID;
	NewCargoData.StackMax = NewCargo->StackMax;
	NewCargoData.Quantity = Quantity;
	NewCargoData.ItemAsset = NewCargo;
	
	if (Cargo.Contains(NewCargoData)) {
		Cargo[Cargo.IndexOfByKey(NewCargoData)].Quantity += Quantity;
	} else
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

TArray<FCargoItemData> UCargoComponent::GetCargo()
{
	return Cargo;
}

int UCargoComponent::GetMaxSlots()
{
	return MaxCargoSlots;
}

