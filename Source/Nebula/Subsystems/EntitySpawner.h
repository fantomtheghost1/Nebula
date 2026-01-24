// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "../Objects/Fleet.h"
#include "../Objects/Ship.h"
#include "Nebula/DataAssets/FleetData.h"
#include "Subsystems/GameInstanceSubsystem.h"
#include "EntitySpawner.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API UEntitySpawner : public UGameInstanceSubsystem
{
	GENERATED_BODY()
	
public:
	
	virtual void Initialize(FSubsystemCollectionBase& Collection) override;
	
	AFleet* SpawnFleet(FTransform SpawnTransform, UFaction* Faction);
	
	AShip* SpawnShip(FTransform SpawnTransform, UFaction* Faction);
	
private:
	
	TArray<UFleetData*> Fleets;
	
};
