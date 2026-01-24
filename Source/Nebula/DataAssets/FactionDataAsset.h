// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Engine/DataAsset.h"
#include "FactionDataAsset.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API UFactionDataAsset : public UPrimaryDataAsset
{
	GENERATED_BODY()

public:
	
	virtual FPrimaryAssetId GetPrimaryAssetId() const override;
	
	UPROPERTY(EditAnywhere, BlueprintReadOnly)
	FName FactionName;
};
