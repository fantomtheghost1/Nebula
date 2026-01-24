// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Faction.h"
#include "Ship.h"
#include "GameFramework/Actor.h"
#include "StarSystem.generated.h"

UCLASS()
class NEBULA_API AStarSystem : public AActor
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	AStarSystem();
	
	virtual void Tick(float DeltaTime) override;
	
	void AddShipToSystem(AShip* Ship);
	
	void GetShipsInSystem(TArray<AShip*>& OutShips);

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;
	
private:
	UPROPERTY(VisibleAnywhere, Category="Ship")
	TArray<AShip*> ShipsInSystem;
	
	UPROPERTY(VisibleAnywhere)
	UFaction* Affiliation;
};
