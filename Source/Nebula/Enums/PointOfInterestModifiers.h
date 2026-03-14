#pragma once

#include "CoreMinimal.h"
#include "PointOfInterestModifiers.generated.h"

UENUM(BlueprintType)
enum class EPointOfInterestModifiers : uint8
{
	SAFE      UMETA(DisplayName="Safe"),
	CONTESTED UMETA(DisplayName="Contested"),
	DEAD      UMETA(DisplayName="Dead")
};
