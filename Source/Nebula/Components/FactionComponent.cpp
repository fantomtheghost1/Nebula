// Fill out your copyright notice in the Description page of Project Settings.


#include "FactionComponent.h"

#include "Nebula/NebulaGameInstance.h"
#include "Nebula/Subsystems/FactionSubsystem.h"

void UFactionComponent::BeginPlay()
{
	Super::BeginPlay();
	
	UNebulaGameInstance* GameInstance = Cast<UNebulaGameInstance>(GetWorld()->GetGameInstance());
	UFactionSubsystem* FactionSubsystem = GameInstance->GetSubsystem<UFactionSubsystem>();
	
	FactionSubsystem->RegisterMemberByName(FactionData->FactionName, GetOwner());
}

