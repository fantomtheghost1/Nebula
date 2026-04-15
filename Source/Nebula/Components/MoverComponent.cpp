#include "MoverComponent.h"
#include "NiagaraComponent.h"

UMoverComponent::UMoverComponent()
{
	PrimaryComponentTick.bCanEverTick = true;
}

void UMoverComponent::BeginPlay()
{
	Super::BeginPlay();
}

void UMoverComponent::TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction)
{
	Super::TickComponent(DeltaTime, TickType, ThisTickFunction);

	if (Waypoints.Num() == 0)
	{
		FlySpeed = 0.0f;
		
		if (UNiagaraComponent* NiagaraComp = GetOwner()->GetComponentByClass<UNiagaraComponent>())
		{
			NiagaraComp->Deactivate();
		}
		return;
	}

	AActor* Owner = GetOwner();
	if (!Owner)
	{
		return;
	}

	const FVector OwnerLocation = Owner->GetActorLocation();
	const FVector TargetLocation = Waypoints[0];
	const float DistanceToTarget = FVector::Dist(OwnerLocation, TargetLocation);

	if (DistanceToTarget <= (ArrivalDistance + ArrivalInaccuracyMargin))
	{
		Waypoints.RemoveAt(0);
		FlySpeed = 0.0f;
		
		if (Waypoints.Num() == 0)
		{
			if (UNiagaraComponent* NiagaraComp = GetOwner()->GetComponentByClass<UNiagaraComponent>())
			{
				NiagaraComp->Deactivate();
			}
		}
		
		return;
	}

	UpdateSpeed(DeltaTime, DistanceToTarget);
	RotateShip(DeltaTime);
	MoveShip(DeltaTime);
}

void UMoverComponent::UpdateSpeed(float DeltaTime, float DistanceToTarget)
{
	const float DesiredSpeed =
		(DistanceToTarget > SlowdownDistance)
		? MaxFlySpeed
		: MaxFlySpeed * FMath::Clamp((DistanceToTarget - ArrivalDistance) / (SlowdownDistance - ArrivalDistance), 0.0f, 1.0f);

	if (FlySpeed < DesiredSpeed)
	{
		FlySpeed = FMath::Min(FlySpeed + Acceleration * DeltaTime, DesiredSpeed);
	}
	else if (FlySpeed > DesiredSpeed)
	{
		FlySpeed = FMath::Max(FlySpeed - Deceleration * DeltaTime, DesiredSpeed);
	}
}

void UMoverComponent::MoveShip(float DeltaTime)
{
	if (Waypoints.Num() == 0)
	{
		return;
	}

	AActor* Owner = GetOwner();
	if (!Owner)
	{
		return;
	}

	const FVector OwnerLocation = Owner->GetActorLocation();
	const FVector TargetLocation = Waypoints[0];
	const FVector ToTarget = TargetLocation - OwnerLocation;
	const float DistanceToTarget = ToTarget.Length();

	if (DistanceToTarget <= KINDA_SMALL_NUMBER)
	{
		return;
	}

	const FVector Direction = ToTarget / DistanceToTarget;
	const float StepDistance = FlySpeed * DeltaTime;

	FVector NewPos = OwnerLocation + Direction * StepDistance;

	if (StepDistance >= (DistanceToTarget + ArrivalInaccuracyMargin))
	{
		NewPos = TargetLocation;
		Waypoints.RemoveAt(0);
		FlySpeed = 0.0f;
	}
	
	Owner->SetActorLocation(NewPos, false);
}

void UMoverComponent::RotateShip(float DeltaTime)
{
	if (Waypoints.Num() == 0)
	{
		return;
	}

	AActor* Owner = GetOwner();
	if (!Owner)
	{
		return;
	}

	const FVector OwnerLocation = Owner->GetActorLocation();
	const FVector Direction = (Waypoints[0] - OwnerLocation).GetSafeNormal();

	if (Direction.IsNearlyZero())
	{
		return;
	}

	const FRotator CurrentRotation = Owner->GetActorRotation();
	const FRotator TargetRotation = Direction.Rotation();
	const FRotator NewRotation = FMath::RInterpTo(CurrentRotation, TargetRotation, DeltaTime, RotationSpeed);

	Owner->SetActorRotation(NewRotation);
}

void UMoverComponent::ClearWaypoints()
{
	Waypoints.Empty();
	FlySpeed = 0.0f;
}

FVector UMoverComponent::GetNextWaypoint()
{
	return Waypoints.Num() > 0 ? Waypoints[0] : FVector::ZeroVector;
}

TArray<FVector> UMoverComponent::GetWaypoints()
{
	return Waypoints;
}

void UMoverComponent::SetNextWaypoint(FVector NewWaypoint)
{
	GetOwner()->GetComponentByClass<UNiagaraComponent>()->Activate(false);
	Waypoints.Add(NewWaypoint);
}

void UMoverComponent::SetFlySpeed(float NewSpeed)
{
	FlySpeed = NewSpeed;
	MaxFlySpeed = NewSpeed;
}

void UMoverComponent::GetFlySpeed(float& OutSpeed)
{
	OutSpeed = FlySpeed;
}

float UMoverComponent::GetMaxFlySpeed()
{
	return MaxFlySpeed;
}