// Fill out your copyright notice in the Description page of Project Settings.


#include "DialogComponent.h"
#include "../NebulaGameInstance.h"
#include "Nebula/Subsystems/DialogueSubsystem.h"
#include "Nebula/Utils/NebulaLogging.h"

void UDialogComponent::StartDialogue()
{
	UWorld* World = GetWorld();
	if (!World) return;
	
	UGameInstance* GI = World->GetGameInstance();
	if (!GI) return;
	
	UNebulaGameInstance* NGI = Cast<UNebulaGameInstance>(GI);
	if (!NGI) return;
	
	UDialogueSubsystem* DSS = NGI->GetSubsystem<UDialogueSubsystem>();
	if (!DSS) return;
	
	UDialogueAsset* Dialogue = DSS->GetDialogueByID(DialogueID);
	
	for (int i = 0; i < Dialogue->Dialogue.Num(); i++)
	{
		UE_LOG(LogDialogue, Warning, TEXT("%s"), *Dialogue->Dialogue[i].DialogueText.ToString());
		
		for (int j = 0; j < Dialogue->Dialogue[i].Choices.Num(); j++)
		{
			UE_LOG(LogDialogue, Warning, TEXT("%s"), *Dialogue->Dialogue[i].Choices[j].ChoiceText.ToString());
		}
	}
}
