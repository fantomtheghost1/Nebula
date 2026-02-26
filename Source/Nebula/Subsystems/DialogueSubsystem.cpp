// Fill out your copyright notice in the Description page of Project Settings.


#include "DialogueSubsystem.h"

#include "Nebula/DataAssets/DialogueAsset.h"
#include "Engine/AssetManager.h"
#include "Nebula/Utils/NebulaLogging.h"

void UDialogueSubsystem::Initialize(FSubsystemCollectionBase& Collection)
{
	TArray<FAssetData> TempDialogue;
	UAssetManager& AM = UAssetManager::Get();
	AM.UpdateManagementDatabase();
	AM.GetPrimaryAssetDataList(
		FPrimaryAssetType("Dialogue"),
		TempDialogue
		);
	
	for (const FAssetData& DialogueItem : TempDialogue)
	{
		UDialogueAsset* DialogueAsset = Cast<UDialogueAsset>(DialogueItem.GetAsset());
		if (DialogueAsset)
		{
			Dialogue.Add(DialogueAsset);
		}
	}
	
	UE_LOG(LogDataAsset, Warning, TEXT("Dialogue Loaded: %d"), Dialogue.Num());
}

UDialogueAsset* UDialogueSubsystem::GetDialogueByID(int ID)
{
	for (int i = 0; i < Dialogue.Num(); i++)
	{
		if (Dialogue[i]->DialogueID == ID) return Dialogue[i];
	}
	
	return nullptr;
}
