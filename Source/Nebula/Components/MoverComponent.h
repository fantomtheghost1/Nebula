// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "AIController.h"
#include "Components/ActorComponent.h"
#include "MoverComponent.generated.h"


UCLASS( ClassGroup=(Custom), meta=(BlueprintSpawnableComponent) )
class NEBULA_API UMoverComponent : public UActorComponent
{
	GENERATED_BODY()

public:	
	// Sets default values for this component's properties
	UMoverComponent();
	
	UFUNCTION(BlueprintCallable)
	void MoveToLocation(FVector NewLocation, AAIController* FleetController);

	virtual void TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction) override;

	void SetTarget(AActor* NewTarget);
	
	float GetFlySpeed();
	
	void SetFlySpeed(float NewFlySpeed);
	
protected:
	// Called when the game starts
	virtual void BeginPlay() override;

private:	
	// Called every frame
	float FlySpeed = 0.0f;
	
	UPROPERTY(VisibleAnywhere)
	FVector TargetLocation;
	
	UPROPERTY(VisibleAnywhere)
	FRotator TurnTarget;
	
	UPROPERTY(VisibleAnywhere)
	AActor* Target;
	
	UPROPERTY(EditAnywhere)
	float TurnRate;
};
