// Fill out your copyright notice in the Description page of Project Settings.


#include "TurretComponent.h"
#include "TimerManager.h"


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
}

void UTurretComponent::Fire()
{
	if (!Target || !TargetHealthComp) {
		GetWorld()->GetTimerManager().ClearTimer(FireTimerHandle);
		return;
	}
	
	UE_LOG(LogTemp, Warning, TEXT("Firing"));
	TargetHealthComp->TakeDamage(TurretDamage);
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
	
	GetWorld()->GetTimerManager().SetTimer(
		FireTimerHandle, this, &UTurretComponent::Fire, TurretFireRate / NumOfTurrets, true
	);
}

