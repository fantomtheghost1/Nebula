// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Engine/DataAsset.h"
#include "FleetData.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API UFleetData : public UPrimaryDataAsset
{
	GENERATED_BODY()
	
public:
	
	virtual FPrimaryAssetId GetPrimaryAssetId() const override;
	
	UPROPERTY(EditAnywhere, BlueprintReadOnly)
	FName FleetName;
	
	UPROPERTY(EditAnywhere, BlueprintReadOnly)
	int FlySpeed;
	
	UPROPERTY(EditAnywhere, BlueprintReadOnly)
	int MaxCargoSlots;
	
	UPROPERTY(EditAnywhere, BlueprintReadOnly)
	float ScannerRange;
	
};
