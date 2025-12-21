// Fill out your copyright notice in the Description page of Project Settings.

#include "NebulaGameMode.h"

#include "NebulaGameInstance.h"

void ANebulaGameMode::InitializeBattle(int NewPlayerFleetCount, int NewAIFleetCount)
{
	AIShipCount = NewAIFleetCount;
	PlayerShipCount = NewPlayerFleetCount;
}

void ANebulaGameMode::SubtractAIShip()
{
	AIShipCount--;
	
	if (AIShipCount <= 0)
	{
		AIShipCount = 0;
		Cast<UNebulaGameInstance>(GetGameInstance())->EndBattle();
	}
}

void ANebulaGameMode::SubtractPlayerShip()
{
	PlayerShipCount--;
	
	if (PlayerShipCount <= 0)
	{
		PlayerShipCount = 0;
		Cast<UNebulaGameInstance>(GetGameInstance())->EndBattle();
	}
}
