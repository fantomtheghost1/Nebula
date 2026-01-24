// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Objects/Fleet.h"
#include "Objects/MapManager.h"
#include "Objects/Ship.h"
#include "Engine/GameInstance.h"
#include "StateStructs/AsteroidState.h"
#include "StateStructs/FleetState.h"
#include "StateStructs/PlanetState.h"
#include "StateStructs/StarbaseState.h"
#include "StateStructs/SystemState.h"
#include "NebulaGameInstance.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API UNebulaGameInstance : public UGameInstance
{
	GENERATED_BODY()
	
public:
	
	void StartBattle(AFleet* PlayerFleet, AFleet* AIFleet);
	
	void EndBattle(bool PlayerWon);
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite)
	TArray<FShipData> PlayerFleetData;
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite)
	TArray<FShipData> AIFleetData;
	
	void UpdateState();
	
	int GetFleetID(AFleet* Fleet);
	
	TMap<int, FSystemState> Systems;
	TMap<int, FFleetState> Fleets;
	TMap<int, FAsteroidState> Asteroids;
	TMap<int, FPlanetState> Planets;
	TMap<int, FStarbaseState> Starbases;
	TMap<int, UFaction*> Factions;
	
	void StartGame();
	
	UFUNCTION(BlueprintCallable)
	UFaction* AddFaction(FString Name, FColor Color);
	
	UFUNCTION(BlueprintCallable)
	void RemoveFaction(FString Name);
	
	UFUNCTION(BlueprintCallable)
	UFaction* GetFactionByName(FString Name);
	
	UPROPERTY(VisibleAnywhere, BlueprintReadWrite)
	bool DoFirstSpawns = true;
	
protected:
	virtual void Init() override;
	
private:
	
	UPROPERTY(EditAnywhere)
	TSubclassOf<AMapManager> MapManagerBlueprint;
	
	int PlayerFleetID = 0;
	
	int OpposingFleetID = 0;
	
};
