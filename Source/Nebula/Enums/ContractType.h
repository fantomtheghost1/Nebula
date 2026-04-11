#pragma once

#include "CoreMinimal.h"
#include "ContractType.generated.h"

UENUM(BlueprintType)
enum class EContractType : uint8
{
	BOUNTY UMETA(DisplayName="Bounty"),
	ESCORT UMETA(DisplayName="Escort"),
	REFUEL UMETA(DisplayName="Refuel")
};