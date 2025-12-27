// Fill out your copyright notice in the Description page of Project Settings.


#include "Scanner.h"

#include "Nebula/Asteroid.h"

// Sets default values for this component's properties
UScanner::UScanner()
{
	SphereComponent = CreateDefaultSubobject<USphereComponent>(TEXT("Scanner Collision"));
	if (GetOwner())
	{
		SphereComponent->RegisterComponent();
		SphereComponent->SetupAttachment(GetOwner()->GetRootComponent());
		//SphereComponent->SetCollisionObjectType(ECC_WorldStatic);
		SphereComponent->SetCollisionProfileName(TEXT("OverlapAllDynamic"));
		SphereComponent->SetCollisionEnabled( ECollisionEnabled::QueryAndPhysics);
	}
}

void UScanner::Scan()
{
 	TArray<AActor*> Actors;
	SphereComponent->GetOverlappingActors(Actors);
	
	FriendlyObjects.Empty();
	NeutralObjects.Empty();
	EnemyObjects.Empty();
	
	for (int i = 0; i < Actors.Num(); i++)
	{
		UE_LOG(LogTemp, Warning, TEXT("Actors Length: %d"), Actors.Num());
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
	
	SphereComponent->SetSphereRadius(ScanRange, true);
}

