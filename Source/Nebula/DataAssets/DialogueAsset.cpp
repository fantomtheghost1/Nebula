// Fill out your copyright notice in the Description page of Project Settings.


#include "DialogueAsset.h"

FPrimaryAssetId UDialogueAsset::GetPrimaryAssetId() const
{
	return FPrimaryAssetId(TEXT("Dialogue"), GetFName());
}
