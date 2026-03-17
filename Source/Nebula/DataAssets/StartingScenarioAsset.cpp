// Fill out your copyright notice in the Description page of Project Settings.


#include "StartingScenarioAsset.h"

FPrimaryAssetId UStartingScenarioAsset::GetPrimaryAssetId() const
{
	return FPrimaryAssetId(TEXT("StartingScenario"), GetFName());
}