// Fill out your copyright notice in the Description page of Project Settings.
#include "FactionDataAsset.h"

FPrimaryAssetId UFactionDataAsset::GetPrimaryAssetId() const
{
	return FPrimaryAssetId(TEXT("FactionAsset"), GetFName());
}