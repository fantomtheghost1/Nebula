// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Subsystems/GameInstanceSubsystem.h"
#include "../DataStructs/Leader.h"
#include "FactionSubsystem.h"
#include "../NebulaGameInstance.h"
#include "LeaderSubsystem.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API ULeaderSubsystem : public UGameInstanceSubsystem
{
	GENERATED_BODY()
	
public:
	
	FLeader GenerateLeader();
	
};
