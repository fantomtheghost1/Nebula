// Fill out your copyright notice in the Description page of Project Settings.


#include "ScenarioSubsystem.h"
#include "Engine/AssetManager.h"

void UScenarioSubsystem::Initialize(FSubsystemCollectionBase& Collection)
{
	Super::Initialize(Collection);
	
	TArray<FAssetData> TempScenarios;
	UAssetManager& AM = UAssetManager::Get();
	AM.GetPrimaryAssetDataList(
		FPrimaryAssetType("StartingScenario"),
		TempScenarios
		);
	
	for (const FAssetData& Scenario : TempScenarios)
	{
		UStartingScenarioAsset* ScenarioAsset = Cast<UStartingScenarioAsset>(Scenario.GetAsset());
		if (ScenarioAsset)
		{
			Scenarios.Add(ScenarioAsset);
		}
	}
	
	UE_LOG(LogTemp, Warning, TEXT("Starting Scenarios Loaded: %d"), Scenarios.Num());
}

UStartingScenarioAsset* UScenarioSubsystem::GetScenarioByID(int ID)
{
	if (ID >= Scenarios.Num()) return nullptr;
	return Scenarios[ID];
}

