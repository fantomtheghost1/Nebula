#pragma once

#include "CoreMinimal.h"
#include "Nebula/Objects/Faction.h"
#include "Leader.generated.h"

USTRUCT(BlueprintType)
struct FLeader
{
	GENERATED_BODY()
	
	FName LeaderName;
	UFaction* LeaderFaction;
};