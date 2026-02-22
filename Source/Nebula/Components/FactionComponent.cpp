// Fill out your copyright notice in the Description page of Project Settings.


#include "FactionComponent.h"

#include "Nebula/NebulaGameInstance.h"
#include "Nebula/Subsystems/FactionSubsystem.h"

void UFactionComponent::BeginPlay()
{
	Super::BeginPlay();
	
	UNebulaGameInstance* GameInstance = Cast<UNebulaGameInstance>(GetWorld()->GetGameInstance());
	if (!GameInstance) return;
	
	UFactionSubsystem* FactionSubsystem = GameInstance->GetSubsystem<UFactionSubsystem>();
	if (!FactionSubsystem) return;
	if (!FactionData) return;
	
	FactionSubsystem->RegisterMemberByName(FactionData->FactionName, GetOwner());
	
	AFleet* Fleet = Cast<AFleet>(GetOwner());
	if (!Fleet) return;
	//if (!Fleet->Leader) return;
	Fleet->Leader.LeaderFaction = FactionSubsystem->GetFactionByName(FactionData->FactionName);
}

