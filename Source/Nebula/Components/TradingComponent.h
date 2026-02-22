// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Components/ActorComponent.h"
#include "../Objects/Fleet.h"
#include "TradingComponent.generated.h"


UCLASS( ClassGroup=(Custom), meta=(BlueprintSpawnableComponent) )
class NEBULA_API UTradingComponent : public UActorComponent
{
	GENERATED_BODY()

public:	
	AFleet* DockedFleet;
	
	UFUNCTION(BlueprintCallable)
	void Trade(UCargoItemAsset* ItemToTrade, bool IsPlayer, bool IsBuying);
};
