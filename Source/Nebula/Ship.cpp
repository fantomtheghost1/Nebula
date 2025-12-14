// Fill out your copyright notice in the Description page of Project Settings.


#include "Ship.h"

#include "Blueprint/UserWidget.h"
#include "Misc/OutputDeviceNull.h"


// Sets default values
AShip::AShip()
{
 	// Set this pawn to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;
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


