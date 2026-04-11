// Fill out your copyright notice in the Description page of Project Settings.


#include "FuelComponent.h"

#include "MoverComponent.h"
#include "Nebula/NebulaPlayerController.h"

void UFuelComponent::AddFuel(float FuelToAdd)
{
	FuelCurrent += FuelToAdd;
	if (FuelCurrent > FuelMax)
	{
		FuelCurrent = FuelMax;
	}
	
	if (FuelCurrent > 0.0f)
	{
		if (APlayerController* PC = GetWorld()->GetFirstPlayerController())
		{
			if (ANebulaPlayerController* NPC = Cast<ANebulaPlayerController>(PC))
			{
				NPC->SetWaypointsDisabled(false);
			}
		}
	}
}

void UFuelComponent::RemoveFuel()
{
	FuelCurrent -= FuelConsumption;
	
	if (FuelCurrent <= 0)
	{
		FuelCurrent = 0;
		
		if (APlayerController* PC = GetWorld()->GetFirstPlayerController())
		{
			if (ANebulaPlayerController* NPC = Cast<ANebulaPlayerController>(PC))
			{
				NPC->SetWaypointsDisabled(true);
			}
		}
	}
}

float UFuelComponent::GetFuel()
{
	return FuelCurrent;
}

// Called when the game starts
void UFuelComponent::BeginPlay()
{
	Super::BeginPlay();
	
	FuelCurrent = FuelMax;

	GetWorld()->GetTimerManager().SetTimer(
		FuelTimer,
		this,
		&UFuelComponent::RemoveFuel,
		FuelConsumptionRate,
		true
	);
}

