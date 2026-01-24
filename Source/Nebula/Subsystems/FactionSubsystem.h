// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "../Objects/Faction.h"
#include "Subsystems/GameInstanceSubsystem.h"
#include "FactionSubsystem.generated.h"

/**
 * 
 */
UCLASS(BlueprintType)
class NEBULA_API UFactionSubsystem : public UGameInstanceSubsystem
{
	GENERATED_BODY()
	
public: 
		
	UFUNCTION(BlueprintCallable)
	UFaction* AddFaction(FString Name, FColor Color);
		
	UFUNCTION(BlueprintCallable)
	void RemoveFaction(FString Name);
		
	UFUNCTION(BlueprintCallable)
	UFaction* GetFactionByName(FString Name);
	
	UFUNCTION(BlueprintCallable)
	int GetNumberOfFactions();
	
	UFUNCTION(BlueprintCallable)
	void ClearFactions();
	
private:
	
	UPROPERTY(VisibleAnywhere)
	TMap<int, UFaction*> Factions;
	
};
