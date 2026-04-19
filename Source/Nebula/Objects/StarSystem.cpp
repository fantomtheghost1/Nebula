// Fill out your copyright notice in the Description page of Project Settings.


#include "StarSystem.h"
#include "../NebulaGameInstance.h"

// Called when the game starts or when spawned
void AStarSystem::BeginPlay()
{
	Super::BeginPlay();
	
	if (ClickFloorSize > 0.0f)
	{
		const float ClickFloorWidth = 0.9f; 
		
		FActorSpawnParameters SpawnParams;
		SpawnParams.Owner = this;
		SpawnParams.Instigator = GetInstigator();
				
		FVector Location = FVector(GetActorLocation().X, GetActorLocation().Y, ZOffset);
		FRotator Rotation = FRotator::ZeroRotator;
		
		AClickFloor* Spawned = GetWorld()->SpawnActor<AClickFloor>(ClickFloorClass, Location, Rotation, SpawnParams);
		Spawned->SetFloorSize(FVector(ClickFloorSize, ClickFloorSize, ClickFloorWidth));
		Spawned->SetVisible(IsVisible);
		Spawned->Tags.Add(FName("ClickFloor"));
	}
	
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
