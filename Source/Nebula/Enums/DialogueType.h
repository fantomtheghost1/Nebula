#pragma once

#include "CoreMinimal.h"
#include "DialogueType.generated.h"

UENUM(BlueprintType)
enum class EDialogueType : uint8
{
	CONVERSATIONAL       UMETA(DisplayName="Conversational"),
	CONFRONTATIONAL      UMETA(DisplayName="Confrontational"),
	CONTRACTUAL          UMETA(DisplayName="Contractual")
};