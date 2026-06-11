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
	
	void RegisterFleet(AFleet* NewFleet);
	
	void RegisterStarbase(AStarbase* NewStarbase);
	
	UFUNCTION(BlueprintCallable)
	AStarbase* GetRandomStarbase();
	
	TArray<AFleet*> GetFleets();
	
	void SubtractAIShip();
	
	void SubtractPlayerShip();
	
	void CheckVictoryCondition();
	
	void SpawnTradeFleet();
	
	AFleet* GetPlayerFleet();
	
private:
	
	UPROPERTY(EditAnywhere, Category = "Trade Fleet")
	TSubclassOf<AFleet> TraderBlueprint;
	
	UPROPERTY(EditAnywhere, Category = "Trade Fleet")
	float TraderSpawnInterval;

	UPROPERTY(EditAnywhere, Category = "Trade Fleet")
	bool SpawnTraders = true;
	
	void StartGame();
	
	void EndGame();
	
	UNebulaGameInstance* GameInstance;
	
	UFactionSubsystem* FactionSubsystem;
	
	TArray<AFleet*> Fleets;
	
	TArray<AStarbase*> Starbases;
	
	int PlayerShipCount = 0;
	
	int AIShipCount = 0;
	
	FTimerHandle TraderSpawnTimer;
};
