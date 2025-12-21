// Fill out your copyright notice in the Description page of Project Settings.


#include "NebulaGameInstance.h"

#include "NebulaGameMode.h"
#include "Kismet/GameplayStatics.h"

void UNebulaGameInstance::StartBattle(AFleet* PlayerFleet, AFleet* AIFleet)
{
	PlayerFleetData = PlayerFleet->GetFleetData();
	AIFleetData = AIFleet->GetFleetData();
	
	ANebulaGameMode* GM = Cast<ANebulaGameMode>(UGameplayStatics::GetGameMode(this));
	GM->InitializeBattle(PlayerFleetData.Num(), AIFleetData.Num());
	
	UGameplayStatics::OpenLevel(this, FName("BattleSpace"));
}

void UNebulaGameInstance::EndBattle()
{
	UGameplayStatics::OpenLevel(this, FName("Main"));
}