// Fill out your copyright notice in the Description page of Project Settings.


#include "StarSystem.h"
#include "../NebulaGameInstance.h"

// Called when the game starts or when spawned
void AStarSystem::BeginPlay()
{
	Super::BeginPlay();
	
	if (AsteroidGeneratorClass)
	{
		FActorSpawnParameters SpawnParams;
		SpawnParams.Owner = this;
		SpawnParams.Instigator = GetInstigator();
				
		FVector Location = GetActorLocation();
		FRotator Rotation = FRotator::ZeroRotator;
				
		AAsteroidGenerator* Spawned = GetWorld()->SpawnActor<AAsteroidGenerator>(AsteroidGeneratorClass, Location, Rotation, SpawnParams);
			
		if (Spawned)
		{
			Spawned->ConfigureGenerator(MaxAttemptsPerAsteroid, AsteroidCount, RadiusMin, RadiusMax, ClearanceRadius, AsteroidBlueprints, OrbitPoint, OrbitRate);
			Spawned->SpawnAsteroids();
		}
	}
}
