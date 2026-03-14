// Fill out your copyright notice in the Description page of Project Settings.

#include "GalaxyManagerSubsystem.h"

void UGalaxyManagerSubsystem::TriggerModifier(APointOfInterest* POI)
{
	TArray NewModifiers = { EPointOfInterestModifiers::SAFE };
	POI->SetModifiers(NewModifiers);
	UE_LOG(LogTemp, Log, TEXT("Setting Modifier"));
}

