// Fill out your copyright notice in the Description page of Project Settings.


#include "FleetData.h"

FPrimaryAssetId UFleetData::GetPrimaryAssetId() const
{
	return FPrimaryAssetId(TEXT("FleetAsset"), GetFName());
}