// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "NebulaGameInstance.h"
#include "GameFramework/GameModeBase.h"
#include "Subsystems/FactionSubsystem.h"
#include "NebulaGameMode.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API ANebulaGameMode : public AGameModeBase
{
	GENERATED_BODY()
	
public:
	
	virtual void BeginPlay() override;
	
	void InitializeBattle(int NewPlayerShipCount, int NewAIShipCount);
	
	void SubtractAIShip();
	
	void SubtractPlayerShip();
	
	void CheckVictoryCondition();
	
private:
	
	void StartGame();
	
	void EndGame();
	
	UNebulaGameInstance* GameInstance;
	
	UFactionSubsystem* FactionSubsystem;
	
	int PlayerShipCount = 0;
	
	int AIShipCount = 0;
};
