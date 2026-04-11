// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Components/ActorComponent.h"
#include "FuelComponent.generated.h"


UCLASS( ClassGroup=(Custom), meta=(BlueprintSpawnableComponent) )
class NEBULA_API UFuelComponent : public UActorComponent
{
	GENERATED_BODY()
	
public:
	
	void AddFuel(float FuelToAdd);
	
	void RemoveFuel();
	
	UFUNCTION(BlueprintCallable)
	float GetFuel();
	
protected:
	// Called when the game starts
	virtual void BeginPlay() override;

private:	
	
	UPROPERTY(EditAnywhere)
	float FuelMax;
	
	UPROPERTY(VisibleAnywhere)
	float FuelCurrent;
	
	UPROPERTY(EditAnywhere)
	float FuelConsumption;
	
	UPROPERTY(EditAnywhere)
	float FuelConsumptionRate;
	
	FTimerHandle FuelTimer;
		
};
