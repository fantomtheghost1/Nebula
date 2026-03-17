// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Nebula/DataAssets/StartingScenarioAsset.h"
#include "Subsystems/GameInstanceSubsystem.h"
#include "ScenarioSubsystem.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API UScenarioSubsystem : public UGameInstanceSubsystem
{
	GENERATED_BODY()
	
public: 
	virtual void Initialize(FSubsystemCollectionBase& Collection) override;
	
	UStartingScenarioAsset* GetScenarioByID(int ID);
	
private:
	
	TArray<UStartingScenarioAsset*> Scenarios;
};
