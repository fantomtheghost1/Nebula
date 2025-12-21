// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Engine/DataAsset.h"
#include "Nebula/DataStructs/CargoItemData.h"
#include "CraftingRecipeAsset.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API UCraftingRecipeAsset : public UPrimaryDataAsset
{
	GENERATED_BODY()
	
public:
	
	virtual FPrimaryAssetId GetPrimaryAssetId() const override;
	
	UPROPERTY(EditAnywhere, BlueprintReadOnly)
	TMap<FName, int> Ingredients;
	
	UPROPERTY(EditAnywhere, BlueprintReadOnly)
	FName Result;
	
	UPROPERTY(EditAnywhere, BlueprintReadOnly)
	int ResultCount;
	
	UPROPERTY(EditAnywhere, BlueprintReadOnly)
	float CraftingTime;
};
