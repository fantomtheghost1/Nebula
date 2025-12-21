// Fill out your copyright notice in the Description page of Project Settings.


#include "CargoItemAsset.h"

FPrimaryAssetId UCargoItemAsset::GetPrimaryAssetId() const
{
	return FPrimaryAssetId(TEXT("CargoItem"), GetFName());
}