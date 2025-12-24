// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Fleet.h"
#include "Planet.h"
#include "Starbase.h"
#include "StarSystem.h"
#include "GameFramework/Actor.h"
#include "MapManager.generated.h"

UCLASS()
class NEBULA_API AMapManager : public AActor
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	AMapManager();
	
	// Called every frame
	virtual void Tick(float DeltaTime) override;

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;
	
private:
	
	UPROPERTY(EditAnywhere)
	TSubclassOf<AFleet> PlayerFleetBlueprint;
	
	UPROPERTY(EditAnywhere)
	TSubclassOf<AFleet> AIFleetBlueprint;
	
	UPROPERTY(EditAnywhere)
	TSubclassOf<AStarSystem> StarSystemBlueprint;
	
	UPROPERTY(EditAnywhere)
	TSubclassOf<AStarbase> StarbaseBlueprint;
	
	UPROPERTY(EditAnywhere)
	TSubclassOf<APlanet> PlanetBlueprint;
	
	UPROPERTY(EditAnywhere)
	TSubclassOf<AAsteroid> AsteroidBlueprint;
};
