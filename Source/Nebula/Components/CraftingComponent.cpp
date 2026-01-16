// Fill out your copyright notice in the Description page of Project Settings.


#include "CraftingComponent.h"

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


