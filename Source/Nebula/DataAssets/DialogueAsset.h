// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Engine/DataAsset.h"
#include "../DataStructs/Dialogue.h"
#include "DialogueAsset.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API UDialogueAsset : public UPrimaryDataAsset
{
	GENERATED_BODY()
	
public:
	virtual FPrimaryAssetId GetPrimaryAssetId() const override;
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Dialogue")
	int DialogueID;
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Dialogue")
	TArray<FDialogueNode> Dialogue;
	
};
