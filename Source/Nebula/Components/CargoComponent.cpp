// Fill out your copyright notice in the Description page of Project Settings.


#include "CargoComponent.h"

// Sets default values for this component's properties
UCargoComponent::UCargoComponent()
{
	PrimaryComponentTick.bCanEverTick = true;
}


// Called when the game starts
void UCargoComponent::BeginPlay()
{
	Super::BeginPlay();
	
	if (MaxCargoSlots <= 0) FMessageLog("PIE").Error(FText::FromString("MaxCargoSlots must be greater than zero."));
}


// Called every frame
void UCargoComponent::TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction)
{
	Super::TickComponent(DeltaTime, TickType, ThisTickFunction);
}

void UCargoComponent::AddCargo(UCargoItemAsset* NewCargo, int Quantity)
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

TArray<FCargoItemData> UCargoComponent::GetCargo()
{
	return Cargo;
}

int UCargoComponent::GetMaxSlots()
{
	return MaxCargoSlots;
}

