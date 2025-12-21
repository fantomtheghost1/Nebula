// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Fleet.h"
#include "Ship.h"
#include "Engine/GameInstance.h"
#include "NebulaGameInstance.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API UNebulaGameInstance : public UGameInstance
{
	GENERATED_BODY()
	
public:
	
	void StartBattle(AFleet* PlayerFleet, AFleet* AIFleet);
	
	void EndBattle();
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite)
	TArray<FShipData> PlayerFleetData;
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite)
	TArray<FShipData> AIFleetData;
};
