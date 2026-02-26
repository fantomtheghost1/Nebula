// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Nebula/DataAssets/DialogueAsset.h"
#include "Subsystems/GameInstanceSubsystem.h"
#include "DialogueSubsystem.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API UDialogueSubsystem : public UGameInstanceSubsystem
{
	GENERATED_BODY()
	
public:
	
	virtual void Initialize(FSubsystemCollectionBase& Collection) override;
	
	UDialogueAsset* GetDialogueByID(int ID);
	
private:
	
	TArray<UDialogueAsset*> Dialogue;
	
};
