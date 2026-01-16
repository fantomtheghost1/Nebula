// Fill out your copyright notice in the Description page of Project Settings.

#include "NebulaGameMode.h"

#include "NebulaGameInstance.h"


void ANebulaGameMode::BeginPlay()
{
	Super::BeginPlay();
	
	GameInstance = Cast<UNebulaGameInstance>(GetGameInstance());
}

void ANebulaGameMode::InitializeBattle(int NewPlayerShipCount, int NewAIShipCount)
{
	AIShipCount = NewAIShipCount;
	PlayerShipCount = NewPlayerShipCount;
}

void ANebulaGameMode::SubtractAIShip()
{
	AIShipCount--;
	
	if (AIShipCount <= 0)
	{
		AIShipCount = 0;
		GameInstance->EndBattle(false);
	}
}

void ANebulaGameMode::SubtractPlayerShip()
{
	PlayerShipCount--;
	
	if (PlayerShipCount <= 0)
	{
		PlayerShipCount = 0;
		GameInstance->EndBattle(true);
	}
}

void ANebulaGameMode::CheckVictoryCondition()
{
	if (GameInstance->Factions.Num() <= 1)
	{
		UE_LOG(LogTemp, Warning, TEXT("Victory Condition Met!"));
		StartGame();
	}
}

void ANebulaGameMode::StartGame()
{
	GameInstance->Factions.Empty();
	GameInstance->StartGame();
	
	GameInstance->Systems.Empty();
	GameInstance->Fleets.Empty();
	GameInstance->Asteroids.Empty();
	GameInstance->Planets.Empty();
	GameInstance->Starbases.Empty();
}

void ANebulaGameMode::EndGame()
{
	GameInstance->StartGame();
}
