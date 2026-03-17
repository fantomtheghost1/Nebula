#pragma once

#include "CoreMinimal.h"
#include "Factions.generated.h"

UENUM(BlueprintType)
enum class EFactions : uint8
{
	RED    UMETA(DisplayName="Red"),
	GREEN  UMETA(DisplayName="Green"),
	BLUE   UMETA(DisplayName="Blue"),
	YELLOW UMETA(DisplayName="Yellow")
};