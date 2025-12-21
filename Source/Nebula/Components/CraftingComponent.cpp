// Fill out your copyright notice in the Description page of Project Settings.


#include "CraftingComponent.h"
#include "Engine/AssetManager.h"

// Called when the game starts
void UCraftingComponent::BeginPlay()
{
	Super::BeginPlay();

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
	
	UE_LOG(LogTemp, Warning, TEXT("Crafting Recipes Loaded: %d"), Recipes.Num());
}

TArray<UCraftingRecipeAsset*> UCraftingComponent::GetRecipes() const
{
	return Recipes;
}

UCraftingRecipeAsset* UCraftingComponent::GetRecipe(FName RecipeName)
{
	for (int i = 0; i < Recipes.Num(); i++)
	{
		if (Recipes[i]->Result == RecipeName) return Recipes[i];
	}
	
	return nullptr;
}

void UCraftingComponent::StartCraft(UCraftingRecipeAsset* Recipe)
{
	UE_LOG(LogTemp, Warning, TEXT("Started crafting %s"), *Recipe->Result.ToString());
	GetWorld()->GetTimerManager().SetTimer(
		ProgressTimer,
		this,
		&UCraftingComponent::Craft,
		Recipe->CraftingTime,   // update interval
		false
	);
	
	RecipeCrafting = Recipe;
}

void UCraftingComponent::Craft()
{
	if (!RecipeCrafting) return;
	
	UCargoComponent* CargoComp = DockedFleet->FindComponentByClass<UCargoComponent>();
	
	for (const TPair<FName, int32>& Elem : RecipeCrafting->Ingredients)
	{
		UCargoItemAsset* ItemAsset = CargoComp->GetCargoItemByID(Elem.Key);
		if (ItemAsset)
		{
			CargoComp->SubtractCargoItem(ItemAsset, Elem.Value);
		} else
		{
			FMessageLog("PIE").Error(FText::FromString("Recipe item ingredient must exist."));
			return;
		}
	}
	
	CargoComp->AddCargoItem(CargoComp->GetCargoItemByID(RecipeCrafting->Result), 1);
	
	UE_LOG(LogTemp, Warning, TEXT("Crafted"));
	
	RecipeCrafting = nullptr;
}


