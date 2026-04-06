#pragma once

#include "CoreMinimal.h"
#include "DiplomacyStates.generated.h"

UENUM(BlueprintType)
enum class EDiplomacyStates : uint8
{
	ALLY    UMETA(DisplayName="Ally"),
	NEUTRAL UMETA(DisplayName="Neutral"),
	ENEMY   UMETA(DisplayName="Enemy"),
	UNKNOWN UMETA(DisplayName="Unknown")
};