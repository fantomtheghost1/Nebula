// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Subsystems/GameInstanceSubsystem.h"
#include "../DataStructs/ContractData.h"
#include "ContractSubsystem.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API UContractSubsystem : public UGameInstanceSubsystem
{
	GENERATED_BODY()
	
public:
	
	FContractData* GetContract(int Index);
	
	void AddContract(FContractData NewContract);
	
	void CompleteContract(int Index);
	
private:
	
	TArray<FContractData> ActiveContracts;
};
