// Fill out your copyright notice in the Description page of Project Settings.


#include "OrbitComponent.h"

UOrbitComponent::UOrbitComponent()
{
	PrimaryComponentTick.bCanEverTick = true;
	PrimaryComponentTick.bStartWithTickEnabled = true;
}

void UOrbitComponent::TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction)
{
	Super::TickComponent(DeltaTime, TickType, ThisTickFunction);
	
	if (!PivotActor) return;
	RotateAroundPivot(PivotActor->GetActorLocation());
}

void UOrbitComponent::RotateAroundPivot(FVector PivotLocation)
{
	
	const FVector OwnerLoc = GetOwner()->GetActorLocation();
	const FVector Offset = OwnerLoc - PivotLocation;

	const FQuat DeltaQ(FVector::UpVector, FMath::DegreesToRadians(RotationRate));
	const FVector NewLoc = PivotLocation + DeltaQ.RotateVector(Offset);

	const FQuat NewRot = DeltaQ * GetOwner()->GetActorQuat();

	GetOwner()->SetActorLocationAndRotation(NewLoc, NewRot, false, nullptr, ETeleportType::None);

}

