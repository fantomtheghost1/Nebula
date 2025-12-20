// Fill out your copyright notice in the Description page of Project Settings.


#include "MoverComponent.h"

// Sets default values for this component's properties
UMoverComponent::UMoverComponent()
{
	PrimaryComponentTick.bCanEverTick = true;
}


// Called when the game starts
void UMoverComponent::BeginPlay()
{
	Super::BeginPlay();
}

// Called every frame
void UMoverComponent::TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction)
{
	Super::TickComponent(DeltaTime, TickType, ThisTickFunction);
	
	if (Waypoints.Num() > 0)
	{
		AActor* Owner = GetOwner();
		FVector OwnerLocation = Owner->GetActorLocation();
		
		FVector Direction = (Waypoints[0] - OwnerLocation).GetSafeNormal();
		FVector NewPos = OwnerLocation + Direction * FlySpeed * DeltaTime;
		Owner->SetActorLocation(NewPos);
		if (FVector::Dist(OwnerLocation, Waypoints[0]) <= FlySpeed * DeltaTime)
		{
			Waypoints.RemoveAt(0);
		}
	}
}

/* WAYPOINT FUNCTIONS */
void UMoverComponent::ClearWaypoints()
{
	Waypoints.Empty();
}

FVector UMoverComponent::GetNextWaypoint()
{
	return Waypoints[0];
}

TArray<FVector> UMoverComponent::GetWaypoints()
{
	return Waypoints;
}

void UMoverComponent::SetNextWaypoint(FVector NewWaypoint)
{
	Waypoints.Add(NewWaypoint);
}

/* FLY FUNCTIONS */
void UMoverComponent::SetFlySpeed(float NewSpeed)
{
	FlySpeed = NewSpeed;
}

void UMoverComponent::GetFlySpeed(float& OutSpeed)
{
	OutSpeed = FlySpeed;
}


