#pragma once

#include "CoreMinimal.h"
#include "../Objects/Faction.h"
#include "FleetState.generated.h"

USTRUCT(BlueprintType)
struct FFleetState
{
	GENERATED_BODY()
	
	FVector Location;
	
	FRotator Rotation;
	
	TArray<FShipData> FleetData;
	
	UFaction* Affiliation;
	
	bool IsPlayer = false;
};
