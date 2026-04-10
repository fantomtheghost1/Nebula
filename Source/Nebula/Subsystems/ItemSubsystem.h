// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "../DataAssets/CargoitemAsset.h"
#include "Subsystems/GameInstanceSubsystem.h"
#include "ItemSubsystem.generated.h"

/**
 * 
 */
UCLASS(BlueprintType)
class NEBULA_API UItemSubsystem : public UGameInstanceSubsystem
{
	GENERATED_BODY()
	
public:
	
	virtual void Initialize(FSubsystemCollectionBase& Collection) override;
	
	UFUNCTION(BlueprintCallable)
	TArray<UCargoItemAsset*> GetItems() const;
	
	UFUNCTION(BlueprintCallable)
	UCargoItemAsset* GetItem(FName ItemName);
	
private:
	
	TArray<UCargoItemAsset*> CargoItemAssets;
	
};
