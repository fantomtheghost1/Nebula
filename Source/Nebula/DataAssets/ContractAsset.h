// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Engine/DataAsset.h"
#include "../Enums/ContractType.h"
#include "ContractAsset.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API UContractAsset : public UPrimaryDataAsset
{
	GENERATED_BODY()
	
public:
	virtual FPrimaryAssetId GetPrimaryAssetId() const override;
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Contract")
	int ContractID;
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Contract")
	FString ContractText;
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Contract")
	int CreditReward;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Contract")
    EContractType ContractType;
};
