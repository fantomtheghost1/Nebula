// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Components/ActorComponent.h"
#include "../Objects/Fleet.h"
#include "Nebula/DataAssets/CraftingRecipeAsset.h"
#include "CraftingComponent.generated.h"


UCLASS( ClassGroup=(Custom), meta=(BlueprintSpawnableComponent) )
class NEBULA_API UCraftingComponent : public UActorComponent
{
	GENERATED_BODY()

public:
	
	UFUNCTION(BlueprintCallable)
	void StartCraft(UCraftingRecipeAsset* Recipe);
	
	UFUNCTION(BlueprintCallable)
	void Craft();
	
	AFleet* DockedFleet;

private:
	
	UCraftingRecipeAsset* RecipeCrafting;
	
	FTimerHandle ProgressTimer;
};
