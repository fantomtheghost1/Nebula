#pragma once

#include "CoreMinimal.h"
#include "../Enums/ContractType.h"
#include "ContractData.generated.h"

USTRUCT(BlueprintType)
struct FContractData
{
	GENERATED_BODY()
	
	UPROPERTY(EditAnywhere)
	int ContractID;
	
	UPROPERTY(EditAnywhere)
	FString ContractText;
	
	UPROPERTY(EditAnywhere)
	int CreditReward;
	
	UPROPERTY(EditAnywhere)
	EContractType ContractType;
};
