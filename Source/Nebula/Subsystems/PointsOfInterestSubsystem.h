// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Nebula/Objects/PointOfInterest.h"
#include "Subsystems/GameInstanceSubsystem.h"
#include "PointsOfInterestSubsystem.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API UPointsOfInterestSubsystem : public UGameInstanceSubsystem
{
	GENERATED_BODY()
	
public:
	
	void RegisterPOI(APointOfInterest* POI);
	void UnregisterPOI(APointOfInterest* POI);
	
	TArray<APointOfInterest*> GetPOIs();
	
private:
	
	TArray<APointOfInterest*> POIs;
	
};
