// Fill out your copyright notice in the Description page of Project Settings.


#include "AsteroidGenerator.h"

#include "Engine/World.h"
#include "CollisionShape.h"
#include "DrawDebugHelpers.h"
#include "GameFramework/Actor.h"

void AAsteroidGenerator::BeginPlay()
{
	Super::BeginPlay();

	if (AsteroidBlueprints.Num() == 0)
	{
		return;
	}

	UWorld* World = GetWorld();
	if (!World)
	{
		return;
	}

	FCollisionQueryParams QueryParams(SCENE_QUERY_STAT(AsteroidSpawnOverlap), false);
	QueryParams.AddIgnoredActor(this);

	for (int32 i = 0; i < AsteroidCount; i++)
	{
		const int32 Index = FMath::RandHelper(AsteroidBlueprints.Num());
		TSubclassOf<AActor> ChosenClass = AsteroidBlueprints[Index];

		if (!ChosenClass)
		{
			continue; // skip empty entries, don't abort the whole spawn
		}

		bool bSpawned = false;

		for (int32 Attempt = 0; Attempt < MaxAttemptsPerAsteroid; ++Attempt)
		{
			const float Radius = FMath::FRandRange(RadiusMin, RadiusMax);
			const float AngleRad = FMath::FRandRange(0.f, 2.f * PI);

			// Spawn around the generator actor, not (0,0,0) in world space
			const FVector SpawnLocation = GetActorLocation() + FVector(
				Radius * FMath::Cos(AngleRad),
				Radius * FMath::Sin(AngleRad),
				0.0f
			);

			const FQuat SpawnRotation = FQuat::Identity;
			const FTransform SpawnTransform(SpawnRotation, SpawnLocation, FVector::OneVector);

			// 1) Pre-check: is this area already occupied?
			const bool bOverlapsSomething = World->OverlapAnyTestByChannel(
				SpawnLocation,
				FQuat::Identity,
				ECC_WorldDynamic, // often fine; change to a custom channel if you have one for asteroids
				FCollisionShape::MakeSphere(ClearanceRadius),
				QueryParams
			);

			if (bOverlapsSomething)
			{
				continue; // try another candidate
			}

			// 2) Spawn with collision handling as a safety net
			FActorSpawnParameters SpawnParams;
			SpawnParams.SpawnCollisionHandlingOverride =
				ESpawnActorCollisionHandlingMethod::DontSpawnIfColliding;

			if (AActor* Spawned = World->SpawnActor<AActor>(ChosenClass, SpawnTransform, SpawnParams))
			{
				bSpawned = true;
				break;
			}
		}

		// If you want, you can log when we fail to find a place:
		// if (!bSpawned) { UE_LOG(LogTemp, Warning, TEXT("Failed to spawn asteroid %d"), i); }
	}
}

