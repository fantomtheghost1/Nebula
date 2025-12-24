// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Fleet.h"
#include "Ship.h"
#include "GameFramework/GameModeBase.h"
#include "NebulaGameMode.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API ANebulaGameMode : public AGameModeBase
{
	GENERATED_BODY()
	
public:
	
	void InitializeBattle(int NewPlayerShipCount, int NewAIShipCount);
	
	void SubtractAIShip();
	
	void SubtractPlayerShip();
	
private:
	
	int PlayerShipCount = 0;
	
	int AIShipCount = 0;
};
