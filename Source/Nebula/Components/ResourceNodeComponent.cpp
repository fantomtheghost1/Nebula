// Fill out your copyright notice in the Description page of Project Settings.
#include "ResourceNodeComponent.h"

#include "Logging/MessageLog.h"

// Sets default values for this component's properties
UResourceNodeComponent::UResourceNodeComponent()
{
	PrimaryComponentTick.bCanEverTick = true;
}

// Called when the game starts
void UResourceNodeComponent::BeginPlay()
{
	Super::BeginPlay();
	
	if (ResourceMax <= 0) FMessageLog("PIE").Error(FText::FromString("ResourceMax must be greater than zero."));
	if (GatherRate <= 0) FMessageLog("PIE").Error(FText::FromString("GatherRate must be greater than zero."));
	if (UpdateInterval <= 0) FMessageLog("PIE").Error(FText::FromString("UpdateInterval must be greater than zero."));
	if (!ResourceItem) FMessageLog("PIE").Error(FText::FromString("ResourceItem must exist."));
	
	ResourceAmount = ResourceMax;
}

// Called every frame
void UResourceNodeComponent::TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction)
{
	Super::TickComponent(DeltaTime, TickType, ThisTickFunction);
}

void UResourceNodeComponent::StartGather()
{
	if (!DockedFleet) return;
	if (!DockingComponent) return;
	
	GetWorld()->GetTimerManager().SetTimer(
		ProgressTimer,
		this,
		&UResourceNodeComponent::GatherResource,
		UpdateInterval,   // update interval
		true
	);
}

void UResourceNodeComponent::GatherResource()
{
	ResourceAmount -= GatherRate;
	DockedFleet->FindComponentByClass<UCargoComponent>()->AddCargo(ResourceItem, GatherRate);
	
	if (DockedFleet->DockedTo == nullptr)
	{
		DockedFleet = nullptr;
		GetWorld()->GetTimerManager().ClearTimer(ProgressTimer);
	}
	
	if (ResourceAmount <= 0.0f)
	{
		GetOwner()->Destroy();
	}
	// Send to player cargo bay
}

