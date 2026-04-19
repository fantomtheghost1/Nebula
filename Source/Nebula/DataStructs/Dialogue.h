#pragma once

#include "CoreMinimal.h"
#include "../Enums/DialogueType.h"
#include "Dialogue.generated.h"

USTRUCT(BlueprintType)
struct FDialogueChoice
{
	GENERATED_BODY()

	UPROPERTY(EditAnywhere, BlueprintReadOnly)
	FText ChoiceText;

	UPROPERTY(EditAnywhere, BlueprintReadOnly)
	int NextNodeID;
	
	UPROPERTY(EditAnywhere, BlueprintReadOnly)
	EDialogueType ChoiceType;
};

USTRUCT(BlueprintType)
struct FDialogueNode
{
	GENERATED_BODY()

	UPROPERTY(EditAnywhere, BlueprintReadOnly)
	int NodeID;

	UPROPERTY(EditAnywhere, BlueprintReadOnly)
	FText DialogueText;

	UPROPERTY(EditAnywhere, BlueprintReadOnly)
	TArray<FDialogueChoice> Choices;

	UPROPERTY(EditAnywhere, BlueprintReadOnly)
	int RequiredContact;
	
	UPROPERTY(EditAnywhere, BlueprintReadOnly)
	int RequiredFaction;
	
	UPROPERTY(EditAnywhere, BlueprintReadOnly)
	int RequiredSystem;
	
	UPROPERTY(EditAnywhere, BlueprintReadOnly)
	int RequiredDiplomacy;
};