// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "UObject/Object.h"
#include "Faction.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API UFaction : public UObject
{
	GENERATED_BODY()
	
public:
	
	UFaction();
	
	void SetName(FString NewName);
	
	void SetColor(FColor NewColor);
	
	FString GetName();
	
	FColor GetColor();
	
private:
	
	UPROPERTY(EditAnywhere, Category="Faction")
	FString Name;
	
	UPROPERTY(EditAnywhere, Category="Faction")
	FColor Color;
	
};
