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

	AActor* Owner = GetOwner();
	if (!Owner)
	{
		return;
	}

	const bool bHasTarget = (Target != nullptr);
	const bool bHasWaypoints = (Waypoints.Num() > 0);

	if (!bHasTarget && !bHasWaypoints)
	{
		FlySpeed = 0.0f;

		if (UNiagaraComponent* NiagaraComp = Owner->GetComponentByClass<UNiagaraComponent>())
		{
			NiagaraComp->Deactivate();
		}
		return;
	}

	const FVector OwnerLocation = Owner->GetActorLocation();
	const FVector Destination = bHasTarget ? Target->GetActorLocation() : Waypoints[0];
	const float DistanceToTarget = FVector::Dist(OwnerLocation, Destination);

	if (DistanceToTarget <= (ArrivalDistance + ArrivalInaccuracyMargin))
	{
		FlySpeed = 0.0f;

		if (!bHasTarget && Waypoints.Num() > 0)
		{
			Waypoints.RemoveAt(0);
		}

		if (!Target && Waypoints.Num() == 0)
		{
			if (UNiagaraComponent* NiagaraComp = Owner->GetComponentByClass<UNiagaraComponent>())
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
	AActor* Owner = GetOwner();
	if (!Owner)
	{
		return;
	}

	const bool bHasTarget = (Target != nullptr);
	const bool bHasWaypoints = (Waypoints.Num() > 0);

	if (!bHasTarget && !bHasWaypoints)
	{
		return;
	}

	const FVector OwnerLocation = Owner->GetActorLocation();
	const FVector Destination = bHasTarget ? Target->GetActorLocation() : Waypoints[0];
	const FVector ToTarget = Destination - OwnerLocation;
	const float DistanceToTarget = ToTarget.Length();

	if (DistanceToTarget <= KINDA_SMALL_NUMBER)
	{
		return;
	}

	const FVector Direction = ToTarget / DistanceToTarget;
	const float StepDistance = FlySpeed * DeltaTime;

	FVector NewPos = OwnerLocation + Direction * StepDistance;

	if (!bHasTarget && StepDistance >= (DistanceToTarget + ArrivalInaccuracyMargin))
	{
		NewPos = Destination;
		Waypoints.RemoveAt(0);
		FlySpeed = 0.0f;
	}

	Owner->SetActorLocation(NewPos, false);
}

void UMoverComponent::RotateShip(float DeltaTime)
{
	AActor* Owner = GetOwner();
	if (!Owner)
	{
		return;
	}

	const bool bHasTarget = (Target != nullptr);
	const bool bHasWaypoints = (Waypoints.Num() > 0);

	if (!bHasTarget && !bHasWaypoints)
	{
		return;
	}

	const FVector OwnerLocation = Owner->GetActorLocation();
	const FVector Destination = bHasTarget ? Target->GetActorLocation() : Waypoints[0];
	const FVector Direction = (Destination - OwnerLocation).GetSafeNormal();

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
	if (UNiagaraComponent* NiagaraComp = GetOwner() ? GetOwner()->GetComponentByClass<UNiagaraComponent>() : nullptr)
	{
		NiagaraComp->Activate(false);
	}

	Target = nullptr;
	Waypoints.Add(NewWaypoint);
}

void UMoverComponent::SetTarget(AActor* NewTarget)
{
	Target = NewTarget;
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