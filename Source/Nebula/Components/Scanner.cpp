// Fill out your copyright notice in the Description page of Project Settings.


#include "Scanner.h"

#include "../Objects/Asteroid.h"
#include "Nebula/Utils/NebulaLogging.h"

void UScanner::Scan()
{
 	TArray<AActor*> Actors;
	SphereComponent->GetOverlappingActors(Actors);
	
	FriendlyObjects.Empty();
	NeutralObjects.Empty();
	EnemyObjects.Empty();
	
	for (int i = 0; i < Actors.Num(); i++)
	{
		UE_LOG(LogGameplay, Warning, TEXT("Actors Length: %d"), Actors.Num());
		if (Actors[i] == GetOwner()) continue;
		
		if (Actors[i]->IsA(AAsteroid::StaticClass()))
		{
			NeutralObjects.Add(Actors[i]);
		} else if (Actors[i]->IsA(AFleet::StaticClass()) && Cast<AFleet>(Actors[i])->IsPlayerFleet)
		{
			EnemyObjects.Add(Actors[i]);
		}
	}
}

void UScanner::BeginPlay()
{
	Super::BeginPlay();
	
	SphereComponent = GetOwner()->FindComponentByClass<USphereComponent>();
	
	UE_LOG(LogGameplay, Warning, TEXT("SphereComp: %s (Parent: %s)"),
		*GetNameSafe(SphereComponent),
		*GetNameSafe(SphereComponent->GetAttachParent()));

	SphereComponent->SetSphereRadius(ScanRange, true);
}

