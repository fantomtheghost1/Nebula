// Fill out your copyright notice in the Description page of Project Settings.

#include "Fleet.h"

#include "Relay.h"
#include "Starbase.h"
#include "Components/TurretComponent.h"

// Sets default values
AFleet::AFleet()
{
 	// Set this pawn to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;

	RootComponent = CreateDefaultSubobject<USceneComponent>(TEXT("Root"));
	
	SpringArmComponent = CreateDefaultSubobject<USpringArmComponent>(TEXT("SpringArm"));
	SpringArmComponent->SetupAttachment(RootComponent);
	
	CameraComponent = CreateDefaultSubobject<UCameraComponent>(TEXT("Camera"));
	CameraComponent->SetupAttachment(SpringArmComponent);

	MeshComponent = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("Mesh"));
	MeshComponent->SetupAttachment(RootComponent);
	
	Mover = CreateDefaultSubobject<UMoverComponent>(TEXT("Mover"));
	
	Cargo = CreateDefaultSubobject<UCargoComponent>(TEXT("Cargo"));
}

// Called when the game starts or when spawned
void AFleet::BeginPlay()
{
	Super::BeginPlay();
}

// Called every frame
void AFleet::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);
}

// Called to bind functionality to input
void AFleet::SetupPlayerInputComponent(UInputComponent* PlayerInputComponent)
{
	Super::SetupPlayerInputComponent(PlayerInputComponent);
}

void AFleet::DetermineInteract(FHitResult HitResult)
{
	if (HitResult.IsValidBlockingHit())
	{
		if (HitResult.GetActor()->ActorHasTag("Targetable") && HitResult.GetActor() != this)
		{
			FindComponentByClass<UTurretComponent>()->SetTarget(HitResult.GetActor());
		} 
		else {
			// If is click floor, move ship
			FVector NewLocation = FVector(HitResult.ImpactPoint.X, HitResult.ImpactPoint.Y, 0.0f);
			FindComponentByClass<UMoverComponent>()->ClearWaypoints();
			FindComponentByClass<UMoverComponent>()->SetNextWaypoint(NewLocation);
			
			if (ARelay* Relay = Cast<ARelay>(HitResult.GetActor()))
			{
				if (Relay)
				{
					Relay->Interact(this);
				}
			}
			else if (AStarbase* Starbase = Cast<AStarbase>(HitResult.GetActor()))
			{
				if (Starbase)
				{
					Starbase->Interact(this);
				}
			}
			else if (AAsteroid* Asteroid = Cast<AAsteroid>(HitResult.GetActor()))
			{
				if (Asteroid)
				{
					Asteroid->Interact(this);
				}
			}
		}
	}
}

TArray<FShipData> AFleet::GetFleetData()
{
	return Fleet;
}
