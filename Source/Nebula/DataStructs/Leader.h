#pragma once

#include "CoreMinimal.h"
#include "Nebula/Objects/Faction.h"
#include "Leader.generated.h"

USTRUCT(BlueprintType)
struct FLeader
{
	GENERATED_BODY()
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Leader")
	FName LeaderName;
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Leader")
	UFaction* LeaderFaction;
};