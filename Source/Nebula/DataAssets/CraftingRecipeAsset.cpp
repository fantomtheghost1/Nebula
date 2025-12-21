// Fill out your copyright notice in the Description page of Project Settings.


#include "CraftingRecipeAsset.h"

FPrimaryAssetId UCraftingRecipeAsset::GetPrimaryAssetId() const
{
	return FPrimaryAssetId(TEXT("CraftingRecipe"), GetFName());
}
