// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "../DataAssets/CraftingRecipeAsset.h"
#include "Subsystems/GameInstanceSubsystem.h"
#include "CraftingRecipeSubsystem.generated.h"

/**
 * 
 */
UCLASS(BlueprintType)
class NEBULA_API UCraftingRecipeSubsystem : public UGameInstanceSubsystem
{
	GENERATED_BODY()
	
public:
	
	virtual void Initialize(FSubsystemCollectionBase& Collection) override;
	
	UFUNCTION(BlueprintCallable)
	TArray<UCraftingRecipeAsset*> GetRecipes() const;
	
	UFUNCTION(BlueprintCallable)
	UCraftingRecipeAsset* GetRecipe(FName RecipeName);
	
private:
	
	TArray<UCraftingRecipeAsset*> Recipes;
	
};
