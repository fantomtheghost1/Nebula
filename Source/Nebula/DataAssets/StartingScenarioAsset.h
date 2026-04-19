// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Engine/DataAsset.h"
#include "StartingScenarioAsset.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API UStartingScenarioAsset : public UPrimaryDataAsset
{
	GENERATED_BODY()
	
public: 
	virtual FPrimaryAssetId GetPrimaryAssetId() const override;
	
	//UPROPERTY(EditAnywhere, BlueprintReadWrite)
	//EFactions StartingFaction;
};
