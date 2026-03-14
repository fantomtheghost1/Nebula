// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Nebula/Objects/PointOfInterest.h"
#include "Subsystems/GameInstanceSubsystem.h"
#include "GalaxyManagerSubsystem.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API UGalaxyManagerSubsystem : public UGameInstanceSubsystem
{
	GENERATED_BODY()
	
public:
	
	void TriggerModifier(APointOfInterest* POI);
	
};
