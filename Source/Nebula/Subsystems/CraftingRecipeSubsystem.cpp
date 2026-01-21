// Fill out your copyright notice in the Description page of Project Settings.


#include "CraftingRecipeSubsystem.h"

#include "../DataAssets/CraftingRecipeAsset.h"
#include "Engine/AssetManager.h"
#include "Nebula/Utils/NebulaLogging.h"

void UCraftingRecipeSubsystem::Initialize(FSubsystemCollectionBase& Collection)
{
	TArray<FAssetData> TempRecipes;
	UAssetManager& AM = UAssetManager::Get();
	AM.GetPrimaryAssetDataList(
		FPrimaryAssetType("CraftingRecipe"),
		TempRecipes
		);
	
	for (const FAssetData& Recipe : TempRecipes)
	{
		UCraftingRecipeAsset* RecipeAsset = Cast<UCraftingRecipeAsset>(Recipe.GetAsset());
		if (RecipeAsset)
		{
			Recipes.Add(RecipeAsset);
		}
	}
	
	UE_LOG(LogDataAsset, Warning, TEXT("Crafting Recipes Loaded: %d"), Recipes.Num());
}

TArray<UCraftingRecipeAsset*> UCraftingRecipeSubsystem::GetRecipes() const
{
	return Recipes;
}

UCraftingRecipeAsset* UCraftingRecipeSubsystem::GetRecipe(FName RecipeName)
{
	for (int i = 0; i < Recipes.Num(); i++)
	{
		if (Recipes[i]->Result == RecipeName) return Recipes[i];
	}
	
	return nullptr;
}