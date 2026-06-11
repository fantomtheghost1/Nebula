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
	
	if (Target || GetOwner()->GetActorLocation() != TargetLocation)
	{
		
	}
	
	if (GetOwner()->GetActorRotation() != TurnTarget)
	{
		FRotator NewRot = FMath::RInterpTo(
		GetOwner()->GetActorRotation(), 
		TurnTarget, 
		DeltaTime, 
		TurnRate);
	
		GetOwner()->SetActorRotation(NewRot);
	}
}

void UMoverComponent::MoveToLocation(FVector NewLocation, AAIController* FleetController)
{
	FVector Direction = NewLocation - GetOwner()->GetActorLocation();
	TurnTarget = FRotator(Direction.Rotation());
	
	UE_LOG(LogTemp, Warning, TEXT("Moving to %s"), *NewLocation.ToString());
	FleetController->MoveToLocation(NewLocation);
}

void UMoverComponent::SetTarget(AActor* NewTarget)
{
	Target = NewTarget;
}

float UMoverComponent::GetFlySpeed()
{
	return FlySpeed;
}

void UMoverComponent::SetFlySpeed(float NewFlySpeed)
{
	FlySpeed = NewFlySpeed;
}
