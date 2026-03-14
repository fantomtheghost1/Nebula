// Fill out your copyright notice in the Description page of Project Settings.


#include "PointsOfInterestSubsystem.h"

void UPointsOfInterestSubsystem::RegisterPOI(APointOfInterest* POI)
{
	POIs.Add(POI);
}

void UPointsOfInterestSubsystem::UnregisterPOI(APointOfInterest* POI)
{
	POIs.Remove(POI);
}

TArray<APointOfInterest*> UPointsOfInterestSubsystem::GetPOIs()
{
	return POIs;
}
