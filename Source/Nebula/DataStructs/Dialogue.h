#pragma once

#include "CoreMinimal.h"
#include "Dialogue.generated.h"

USTRUCT(BlueprintType)
struct FDialogueChoice
{
	GENERATED_BODY()

	UPROPERTY(EditAnywhere, BlueprintReadOnly)
	FText ChoiceText;

	UPROPERTY(EditAnywhere, BlueprintReadOnly)
	int NextNodeID;
};

USTRUCT(BlueprintType)
struct FDialogueNode
{
	GENERATED_BODY()

	UPROPERTY(EditAnywhere)
	int NodeID;

	UPROPERTY(EditAnywhere)
	FText DialogueText;

	UPROPERTY(EditAnywhere)
	TArray<FDialogueChoice> Choices;

	UPROPERTY(EditAnywhere)
	int RequiredContact;
	
	UPROPERTY(EditAnywhere)
	int RequiredFaction;
	
	UPROPERTY(EditAnywhere)
	int RequiredSystem;
	
	UPROPERTY(EditAnywhere)
	int RequiredDiplomacy;
};