// Fill out your copyright notice in the Description page of Project Settings.


#include "SpawnZone.h"
#include "GameFramework/Actor.h"
#include "Engine/World.h"
#include "TimerManager.h"

void ASpawnZone::BeginPlay()
{
	Super::BeginPlay();

	if (!GetWorld())
	{
		UE_LOG(LogTemp, Error, TEXT("SpawnZone has no World in BeginPlay"));
		return;
	}

	if (SpawnRate <= 0.f)
	{
		UE_LOG(LogTemp, Error, TEXT("SpawnRate must be > 0 (currently: %f). Timer will not fire."), SpawnRate);
		return;
	}

	if (!SpawnActor)
	{
		UE_LOG(LogTemp, Error, TEXT("SpawnActor is not set. Spawn() would have nothing to spawn."));
	}

	GetWorld()->GetTimerManager().SetTimer(
		SpawnTimer,
		this,
		&ASpawnZone::Spawn,
		SpawnRate,
		true,
		SpawnRate
	);

	UE_LOG(LogTemp, Warning, TEXT("Timer Set! Rate=%f Active=%d"),
		SpawnRate,
		GetWorld()->GetTimerManager().IsTimerActive(SpawnTimer));
}

void ASpawnZone::Spawn()
{
	if (!SpawnActor)
	{
		UE_LOG(LogTemp, Warning, TEXT("Spawn() called but SpawnActor is null."));
		return;
	}

	UE_LOG(LogTemp, Warning, TEXT("Spawned %s"), *SpawnActor->GetName());

	const FVector SpawnLocation = FVector(
		FMath::FRandRange(-Size, Size),
		FMath::FRandRange(-Size, Size),
		10
	);

	const FRotator SpawnRotation = FRotator::ZeroRotator;
	const FTransform SpawnTransform(SpawnRotation, SpawnLocation, FVector::OneVector);

	FActorSpawnParameters SpawnParams;
	SpawnParams.SpawnCollisionHandlingOverride =
		ESpawnActorCollisionHandlingMethod::DontSpawnIfColliding;

	AActor* Spawned = GetWorld()->SpawnActor<AActor>(SpawnActor, SpawnTransform, SpawnParams);
	UE_LOG(LogTemp, Warning, TEXT("SpawnActor result: %s"), Spawned ? TEXT("Success") : TEXT("Failed"));
}

