// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Engine/DataAsset.h"
#include "CargoItemAsset.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API UCargoItemAsset : public UPrimaryDataAsset
{
	GENERATED_BODY()
	
public: 
	virtual FPrimaryAssetId GetPrimaryAssetId() const override;
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Cargo")
	FName ItemID = "";
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Cargo")
	int StackMax = 0;
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Cargo")
	int SalePrice = 0;
};
