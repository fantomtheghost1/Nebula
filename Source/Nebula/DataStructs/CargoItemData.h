#pragma once

#include "CoreMinimal.h"
#include "Nebula/DataAssets/CargoItemAsset.h"
#include "CargoItemData.generated.h"

USTRUCT(BlueprintType)
struct FCargoItemData
{
	GENERATED_BODY()
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Cargo")
	FName ItemID = "";
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Cargo")
	int Quantity = 0;
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Cargo")
	int StackMax = 0;
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Cargo")
	int SalePrice = 0;
	
	UCargoItemAsset* ItemAsset;
	
	bool operator==(const FCargoItemData& Other) const
	{
		return ItemID == Other.ItemID;
	}
};