// Fill out your copyright notice in the Description page of Project Settings.


#include "SystemEffectHandler.h"

#include "Kismet/GameplayStatics.h"
#include "Nebula/Utils/NebulaLogging.h"

// Sets default values
ASystemEffectHandler::ASystemEffectHandler()
{
 	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;

}

// Called when the game starts or when spawned
void ASystemEffectHandler::BeginPlay()
{
	Super::BeginPlay();
	
	AGameModeBase* GM = UGameplayStatics::GetGameMode(GetWorld());
	if (!GM) return;
	
	GameMode = Cast<ANebulaGameMode>(GM);
	if (!GameMode) return;
	
	StartEffectTimer();
}

void ASystemEffectHandler::ActivateEffect()
{
	if (Effect == ESystemEffects::SolarFlare)
	{
		for (int i = 0; i < GameMode->GetFleets().Num(); i++)
		{
			AFleet* CurrentFleet = GameMode->GetFleets()[i];
			
			// Convert float to percentage
			float SlowdownAmount;
			CurrentFleet->FindComponentByClass<UMoverComponent>()->GetFlySpeed(SlowdownAmount);
			SlowdownAmount *= (SlowdownPercent / 100.0f);
			
			CurrentFleet->FindComponentByClass<UMoverComponent>()->SetFlySpeed(SlowdownPercent);
			
			GetWorld()->GetTimerManager().SetTimer(
				EffectIntervalTimer,
				this,
				&ASystemEffectHandler::StartEffectTimer,
				EffectDuration,
				false
			);
			UE_LOG(LogSystemEffects, Warning, TEXT("Effect interval started"));
		}
	}
}

void ASystemEffectHandler::StartEffectTimer() {
	for (int i = 0; i < GameMode->GetFleets().Num(); i++)
	{
		AFleet* CurrentFleet = GameMode->GetFleets()[i];
			
		float FlySpeed = CurrentFleet->FindComponentByClass<UMoverComponent>()->GetMaxFlySpeed();
		CurrentFleet->FindComponentByClass<UMoverComponent>()->SetFlySpeed(FlySpeed);
	}
	
	GetWorld()->GetTimerManager().SetTimer(
		EffectTimer,
		this,
		&ASystemEffectHandler::ActivateEffect,
		EffectDuration,
		false
	);
	UE_LOG(LogSystemEffects, Warning, TEXT("Effect started"));
}

