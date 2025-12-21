// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Components/ActorComponent.h"
#include "Nebula/Fleet.h"
#include "Nebula/DataAssets/CargoItemAsset.h"
#include "ResourceNodeComponent.generated.h"

UCLASS( ClassGroup=(Custom), meta=(BlueprintSpawnableComponent) )
class NEBULA_API UResourceNodeComponent : public UActorComponent
{
	GENERATED_BODY()

public:	
	
	// Sets default values for this component's properties
	UResourceNodeComponent();
	
	UFUNCTION(BlueprintCallable)
	void StartGather();
	
	UFUNCTION(BlueprintCallable)
	void StopGather();
	
	void GatherResource();
	
	UPROPERTY(VisibleAnywhere)
	AFleet* DockedFleet;
	
	UFUNCTION(BlueprintCallable)
	int GetResourceMax();
	
	UFUNCTION(BlueprintCallable)
	int GetResourceAmount();

protected:
	// Called when the game starts
	virtual void BeginPlay() override;

private:	
	
	UPROPERTY(EditAnywhere)
	UCargoItemAsset* ResourceItem;
	
	UPROPERTY(EditAnywhere)
	int ResourceMax;
	
	UPROPERTY(VisibleAnywhere)
	int ResourceAmount; // amount / amountmax == percentage
	
	UPROPERTY(EditAnywhere)
	float GatherRate;
	
	UPROPERTY(EditAnywhere)
	float UpdateInterval;
	
	FTimerHandle ProgressTimer;
};
