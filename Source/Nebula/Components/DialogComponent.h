// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Components/ActorComponent.h"
#include "DialogComponent.generated.h"


UCLASS( ClassGroup=(Custom), meta=(BlueprintSpawnableComponent) )
class NEBULA_API UDialogComponent : public UActorComponent
{
	GENERATED_BODY()
	
public:
	void StartDialogue();
	
private:
	UPROPERTY(EditAnywhere)
	int DialogueID;
	
		
};
