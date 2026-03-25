// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "AsteroidGenerator.h"
#include "ClickFloor.h"
#include "Faction.h"
#include "Ship.h"
#include "GameFramework/Actor.h"
#include "StarSystem.generated.h"

UCLASS()
class NEBULA_API AStarSystem : public AActor
{
	GENERATED_BODY()
	
public:	
	
	void AddShipToSystem(AShip* Ship);
	
	void GetShipsInSystem(TArray<AShip*>& OutShips);

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;
	
private:
	
    // ASTEROID GENERATOR
	UPROPERTY(EditAnywhere, Category="Asteroid Generator")
	TSubclassOf<AAsteroidGenerator> AsteroidGeneratorClass;
	
	UPROPERTY(EditAnywhere, Category="Asteroid Generator", meta=(EditCondition="AsteroidGeneratorClass != nullptr", EditConditionHides))
	int MaxAttemptsPerAsteroid;
	
	UPROPERTY(EditAnywhere, Category="Asteroid Generator", meta=(EditCondition="AsteroidGeneratorClass != nullptr", EditConditionHides))
	int AsteroidCount;
	
	UPROPERTY(EditAnywhere, Category="Asteroid Generator", meta=(EditCondition="AsteroidGeneratorClass != nullptr", EditConditionHides))
	float RadiusMin;
	
	UPROPERTY(EditAnywhere, Category="Asteroid Generator", meta=(EditCondition="AsteroidGeneratorClass != nullptr", EditConditionHides))
	float RadiusMax;
	
	UPROPERTY(EditAnywhere, Category="Asteroid Generator", meta=(EditCondition="AsteroidGeneratorClass != nullptr", EditConditionHides))
	float ClearanceRadius;
	
	UPROPERTY(EditAnywhere, Category="Asteroid Generator", meta=(EditCondition="AsteroidGeneratorClass != nullptr", EditConditionHides))
	TArray<TSubclassOf<AActor>> AsteroidBlueprints;
	
	UPROPERTY(EditAnywhere, Category="Asteroid Generator", meta=(EditCondition="AsteroidGeneratorClass != nullptr", EditConditionHides))
	AActor* OrbitPoint;
	
	// CLICK FLOOR
	UPROPERTY(EditAnywhere, Category="Click Floor")
	TSubclassOf<AClickFloor> ClickFloorClass;
	
	UPROPERTY(EditAnywhere, Category="Click Floor", meta=(EditCondition="ClickFloorClass != nullptr", EditConditionHides))
	float ClickFloorSize;
	
	UPROPERTY(EditAnywhere, Category="Click Floor", meta=(EditCondition="ClickFloorClass != nullptr", EditConditionHides))
	float ZOffset;
	
	UPROPERTY(EditAnywhere, Category="Click Floor", meta=(EditCondition="ClickFloorClass != nullptr", EditConditionHides))
	bool IsVisible;
	
	// INFORMATION
	UPROPERTY(VisibleAnywhere, Category="Information")
	TArray<AShip*> ShipsInSystem;
	
	UPROPERTY(VisibleAnywhere, Category="Information")
	UFaction* Affiliation;
};
