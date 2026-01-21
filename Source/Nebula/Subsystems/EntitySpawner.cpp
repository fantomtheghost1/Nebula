// Fill out your copyright notice in the Description page of Project Settings.


#include "EntitySpawner.h"
#include "Engine/AssetManager.h"
#include "Nebula/DataAssets/FleetData.h"
#include "Nebula/Utils/NebulaLogging.h"

void UEntitySpawner::Initialize(FSubsystemCollectionBase& Collection)
{
	Super::Initialize(Collection);
	
	TArray<FAssetData> FleetAssets;
	UAssetManager& AM = UAssetManager::Get();
	AM.GetPrimaryAssetDataList(
		FPrimaryAssetType("FleetAsset"),
		FleetAssets
		);
	
	for (const FAssetData& Fleet : FleetAssets)
	{
		UFleetData* FleetAsset = Cast<UFleetData>(Fleet.GetAsset());
		if (FleetAsset)
		{
			Fleets.Add(FleetAsset);
		}
	}
	
	UE_LOG(LogDataAsset, Warning, TEXT("Fleets Loaded: %d"), Fleets.Num());
}

AFleet* UEntitySpawner::SpawnFleet(FTransform SpawnTransform, UFaction* Faction)
{
	return nullptr;
}

AShip* UEntitySpawner::SpawnShip(FTransform SpawnTransform, UFaction* Faction)
{
	return nullptr;
}
