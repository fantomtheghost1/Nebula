// Fill out your copyright notice in the Description page of Project Settings.


#include "StarSystem.h"

#include "NebulaGameInstance.h"

// Sets default values
AStarSystem::AStarSystem()
{
	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;
}

// Called when the game starts or when spawned
void AStarSystem::BeginPlay()
{
	Super::BeginPlay();
	
	if (UFaction** Found = Cast<UNebulaGameInstance>(GetGameInstance())->Factions.Find(1))
	{
		Affiliation = *Found;
	}
}

// Called every frame
void AStarSystem::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);
}

void AStarSystem::AddShipToSystem(AShip* Ship)
{
	ShipsInSystem.Add(Ship);
}

void AStarSystem::GetShipsInSystem(TArray<AShip*>& OutShips)
{
	OutShips = ShipsInSystem;
}

