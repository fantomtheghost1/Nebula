// Fill out your copyright notice in the Description page of Project Settings.


#include "HealthComponent.h"

#include "Kismet/GameplayStatics.h"
#include "Nebula/NebulaGameMode.h"
#include "Nebula/Ship.h"

// Sets default values for this component's properties
UHealthComponent::UHealthComponent()
{
	PrimaryComponentTick.bCanEverTick = true;
}

void UHealthComponent::BeginPlay()
{
	Super::BeginPlay();
	
	Hull = MaxHull;
	Shield = MaxShield;
}

// Called every frame
void UHealthComponent::TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction)
{
	Super::TickComponent(DeltaTime, TickType, ThisTickFunction);
}

void UHealthComponent::TakeDamage(float DamageAmount)
{
	Shield -= DamageAmount;
	DamageAmount += -Shield;
	if (Shield <= 0.0f)
	{
		Shield = 0.0f;
	}
	
	if (DamageAmount <= 0.0f) return;
	
	Hull -= DamageAmount;
	if (Hull <= 0.0f)
	{
		Hull = 0.0f;
		Dead = true;
		
		if (GetOwner()->IsA(AShip::StaticClass()))
		{
			ANebulaGameMode* GM = Cast<ANebulaGameMode>(UGameplayStatics::GetGameMode(this));
			if (Cast<AShip>(GetOwner())->IsPlayerShip)
			{
				GM->SubtractPlayerShip();
			} else
			{
				GM->SubtractAIShip();
			}
		}
		GetOwner()->Destroy();
	}
}

void UHealthComponent::Heal(float HealAmount)
{
	Hull += HealAmount;
	if (Hull > MaxHull)
	{
		Hull = MaxHull;
	}
}

bool UHealthComponent::IsDead()
{
	return Dead;
}

float UHealthComponent::GetHullPercent()
{
	return MaxHull > 0.0f ? Hull / MaxHull : 0.0f;
}

float UHealthComponent::GetShieldPercent()
{
	return MaxShield > 0.0f ? Shield / MaxShield : 0.0f;
}

float UHealthComponent::GetMaxHull()
{
	return MaxHull;
}

float UHealthComponent::GetMaxShield()
{
	return MaxShield;
}

