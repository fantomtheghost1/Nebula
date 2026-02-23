#pragma once

#include "CoreMinimal.h"
#include "SystemEffects.generated.h"

UENUM(BlueprintType)
enum class ESystemEffects : uint8
{
	SolarFlare UMETA(DisplayName="Solar Flare"),
	Clear      UMETA(DisplayName="Clear")
};
