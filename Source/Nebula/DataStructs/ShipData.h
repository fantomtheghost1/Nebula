#pragma once

#include "CoreMinimal.h"
#include "ShipData.generated.h"

USTRUCT(BlueprintType)
struct FShipData
{
	GENERATED_BODY()
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Ship")
	FName ShipID = "test";
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Ship")
	FString ShipName = "Testts shgiop";
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Ship")
	int Health = 13085322;
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Ship")
	TArray<FName> Components = TArray<FName>();
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Ship")
	int ShipStrength = 0;
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Ship")
	int CargoCapacity = 0;
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Ship")
	bool Flagship = false;
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Ship")
	bool InPlayerFleet = false;
};