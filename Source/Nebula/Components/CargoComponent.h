// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Components/ActorComponent.h"
#include "../DataStructs/CargoItemData.h"
#include "Nebula/DataAssets/CargoItemAsset.h"
#include "CargoComponent.generated.h"

DECLARE_DYNAMIC_MULTICAST_DELEGATE(FCargoChanged);

UCLASS( ClassGroup=(Custom), meta=(BlueprintSpawnableComponent) )
class NEBULA_API UCargoComponent : public UActorComponent
{
	GENERATED_BODY()

public:	

	UPROPERTY(BlueprintAssignable, Category="Events")
	FCargoChanged CargoChanged;
	
	void AddCargoItem(UCargoItemAsset* NewCargo, float Weight);
	
	void AddCargo(UCargoComponent* OtherCargo);
	
	void SubtractCargoItem(UCargoItemAsset* NewCargo, int Quantity);
	
	UFUNCTION(BlueprintCallable, Category="Cargo")
	void RemoveCargo();
	
	UFUNCTION(BlueprintCallable, Category="Cargo")
	TArray<FCargoItemData> GetCargo();
	
	UFUNCTION(BlueprintCallable, Category="Cargo")
	int GetCargoWeight(FName ItemID);
	
	UFUNCTION(BlueprintCallable, Category="Cargo")
	float GetWeight();
	
	UFUNCTION(BlueprintCallable, Category="Cargo")
	float GetMaxWeight();
	
	UPROPERTY(EditAnywhere)
	TArray<FCargoItemData> Cargo;

protected:
	// Called when the game starts
	virtual void BeginPlay() override;

private:	
	
	UPROPERTY(EditAnywhere)
	float MaxWeight;
	
	
};
