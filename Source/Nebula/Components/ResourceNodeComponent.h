// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "DockingComponent.h"
#include "Components/ActorComponent.h"
#include "Nebula/DataAssets/CargoItemAsset.h"
#include "ResourceNodeComponent.generated.h"


UCLASS( ClassGroup=(Custom), meta=(BlueprintSpawnableComponent) )
class NEBULA_API UResourceNodeComponent : public UActorComponent
{
	GENERATED_BODY()

public:	
	// Sets default values for this component's properties
	UResourceNodeComponent();
	
	// Called every frame
	virtual void TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction) override;
	
	UFUNCTION(BlueprintCallable)
	void StartGather();
	
	void GatherResource();
	
	UPROPERTY(VisibleAnywhere)
	UDockingComponent* DockingComponent;
	
	UPROPERTY(VisibleAnywhere)
	AFleet* DockedFleet;

protected:
	// Called when the game starts
	virtual void BeginPlay() override;

private:	
	
	UPROPERTY(EditAnywhere)
	UCargoItemAsset* ResourceItem;
	
	UPROPERTY(EditAnywhere)
	int ResourceMax;
	
	UPROPERTY(VisibleAnywhere)
	int ResourceAmount;
	
	UPROPERTY(EditAnywhere)
	float GatherRate;
	
	UPROPERTY(EditAnywhere)
	float UpdateInterval;
	
	FTimerHandle ProgressTimer;
};
