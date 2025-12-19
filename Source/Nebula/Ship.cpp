// Fill out your copyright notice in the Description page of Project Settings.


#include "Ship.h"

#include "Relay.h"
#include "Starbase.h"

// Sets default values
AShip::AShip()
{
 	// Set this pawn to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;
	Tags.Add(FName(TEXT("CombatTarget")));
	Tags.Add(FName(TEXT("Targetable")));
}

// Called when the game starts or when spawned
void AShip::BeginPlay()
{
	Super::BeginPlay();
}

// Called every frame
void AShip::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);
	
	if (Waypoints.Num() > 0)
	{
		//FVector NewPos = FMath::VInterpTo(GetActorLocation(), Waypoints[0], DeltaTime, FlySpeed);
		FVector Direction = (Waypoints[0] - GetActorLocation()).GetSafeNormal();
		FVector NewPos = GetActorLocation() + Direction * FlySpeed * DeltaTime;
		SetActorLocation(NewPos);
		if (FVector::Dist(GetActorLocation(), Waypoints[0]) <= FlySpeed * DeltaTime)
		{
			Waypoints.RemoveAt(0);
		}
	}
	
	/*if (Target->ActorHasTag("MiningTarget") && IsMiner)
	{
		
		Target->Mine();
	}*/
}

// Called to bind functionality to input
void AShip::SetupPlayerInputComponent(UInputComponent* PlayerInputComponent)
{
	Super::SetupPlayerInputComponent(PlayerInputComponent);
}

/* WAYPOINT FUNCTIONS */
void AShip::ClearWaypoints()
{
	Waypoints.Empty();
}

void AShip::DetermineInteract(FHitResult HitResult)
{
	if (HitResult.IsValidBlockingHit())
	{
		if (HitResult.GetActor()->ActorHasTag("Targetable") && HitResult.GetActor() != this)
		{
			Target = HitResult.GetActor();
		} 
		else {
			// If is click floor, move ship
			FVector NewLocation = FVector(HitResult.ImpactPoint.X, HitResult.ImpactPoint.Y, 0.0f);
			ClearWaypoints();
			SetNextWaypoint(NewLocation);
			
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
					Starbase->Interact();
				}
			}
			else if (AAsteroid* Asteroid = Cast<AAsteroid>(HitResult.GetActor()))
			{
				if (Asteroid)
				{
					Asteroid->Interact();
				}
			}
		}
	}
}

FVector AShip::GetNextWaypoint()
{
	return Waypoints[0];
}

TArray<FVector> AShip::GetWaypoints()
{
	return Waypoints;
}

void AShip::SetNextWaypoint(FVector NewWaypoint)
{
	Waypoints.Add(NewWaypoint);
}

/* FLY FUNCTIONS */
void AShip::SetFlySpeed(float NewSpeed)
{
	FlySpeed = NewSpeed;
}

void AShip::GetFlySpeed(float& OutSpeed)
{
	OutSpeed = FlySpeed;
}


