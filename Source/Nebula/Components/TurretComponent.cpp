// Fill out your copyright notice in the Description page of Project Settings.


#include "TurretComponent.h"
#include "TimerManager.h"
#include "../Objects/Ship.h"
#include "Nebula/Utils/NebulaLogging.h"


// Sets default values for this component's properties
UTurretComponent::UTurretComponent()
{
	// Set this component to be initialized when the game starts, and to be ticked every frame.  You can turn these features
	// off to improve performance if you don't need them.
	PrimaryComponentTick.bCanEverTick = true;

	// ...
}


// Called when the game starts
void UTurretComponent::BeginPlay()
{
	Super::BeginPlay();
	
	LaserMeshComponent = Cast<AShip>(GetOwner())->LaserMeshComponent;
}

void UTurretComponent::Fire()
{
	if (!Target || !TargetHealthComp) {
		GetWorld()->GetTimerManager().ClearTimer(FireTimerHandle);
		return;
	}
	
	const float CentimeterOffset = 100.0f;
	FVector Direction = (Target->GetActorLocation() - GetOwner()->GetActorLocation()).GetSafeNormal();
	float Length = (FVector::Dist(GetOwner()->GetActorLocation(), Target->GetActorLocation()) / CentimeterOffset);
	FRotator Rotation = FRotationMatrix::MakeFromX(Direction).Rotator();
	FVector NewScale = FVector(Length, 1.0f, 1.0f);
	
	LaserMeshComponent->SetWorldRotation(Rotation);
	LaserMeshComponent->SetWorldScale3D(NewScale);
	LaserMeshComponent->SetWorldLocation((GetOwner()->GetActorLocation() + Target->GetActorLocation()) * 0.5f);
	LaserMeshComponent->SetVisibility(true);
	
	TargetHealthComp->TakeDamage(TurretDamage);
	
	GetWorld()->GetTimerManager().SetTimer(
		LaserDisappearHandle, this, &UTurretComponent::DisappearLaser, LaserDuration, false
		);
}

void UTurretComponent::DisappearLaser()
{
	UE_LOG(LogGameplay, Warning, TEXT("Disappearing laser"));
	LaserMeshComponent->SetVisibility(false);
}

int UTurretComponent::GetDamage() {
	return TurretDamage;
}

// Called every frame
void UTurretComponent::TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction)
{
	Super::TickComponent(DeltaTime, TickType, ThisTickFunction);
}

void UTurretComponent::SetTarget(AActor* NewTarget)
{
	Target = NewTarget;
	TargetHealthComp = Target->FindComponentByClass<UHealthComponent>();
	
	for (int i = 0; i < NumOfTurrets; i++)
	{
		float Offset = (i / (float)NumOfTurrets) * TurretFireRate;
		UE_LOG(LogGameplay, Warning, TEXT("Offset: %f"), Offset);
		GetWorld()->GetTimerManager().SetTimer(
			FireTimerHandle, this, &UTurretComponent::Fire, TurretFireRate + Offset, true
		);
	}
}

