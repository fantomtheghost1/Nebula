// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Components/ActorComponent.h"
#include "Nebula/Fleet.h"
#include "Nebula/DataAssets/CraftingRecipeAsset.h"
#include "CraftingComponent.generated.h"


UCLASS( ClassGroup=(Custom), meta=(BlueprintSpawnableComponent) )
class NEBULA_API UCraftingComponent : public UActorComponent
{
	GENERATED_BODY()

public:	
	
	UFUNCTION(BlueprintCallable)
	TArray<UCraftingRecipeAsset*> GetRecipes() const;
	
	UFUNCTION(BlueprintCallable)
	UCraftingRecipeAsset* GetRecipe(FName RecipeName);
	
	UFUNCTION(BlueprintCallable)
	void StartCraft(UCraftingRecipeAsset* Recipe);
	
	UFUNCTION(BlueprintCallable)
	void Craft();
	
	AFleet* DockedFleet;

protected:
	// Called when the game starts
	virtual void BeginPlay() override;

private:
	
	TArray<UCraftingRecipeAsset*> Recipes;
	
	UCraftingRecipeAsset* RecipeCrafting;
	
	FTimerHandle ProgressTimer;
};
