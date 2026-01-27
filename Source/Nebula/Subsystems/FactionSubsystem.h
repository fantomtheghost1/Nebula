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
	UFaction* AddFaction(FName Name, FColor Color);
		
	UFUNCTION(BlueprintCallable)
	void RemoveFaction(FName Name);
		
	UFUNCTION(BlueprintCallable)
	UFaction* GetFactionByName(FName Name);
	
	UFUNCTION(BlueprintCallable)
	void RegisterMemberByName(FName Name, AActor* Member);
	
	UFUNCTION(BlueprintCallable)
	int GetNumberOfFactions();
	
	UFUNCTION(BlueprintCallable)
	void ClearFactions();
	
private:
	
	UPROPERTY(VisibleAnywhere)
	TMap<int, UFaction*> Factions;
	
};
