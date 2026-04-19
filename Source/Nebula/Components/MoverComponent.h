// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Components/ActorComponent.h"
#include "MoverComponent.generated.h"


UCLASS( ClassGroup=(Custom), meta=(BlueprintSpawnableComponent) )
class NEBULA_API UMoverComponent : public UActorComponent
{
	GENERATED_BODY()

public:	
	// Sets default values for this component's properties
	UMoverComponent();

	virtual void TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction) override;

	UFUNCTION(BlueprintCallable)
	void SetFlySpeed(float NewSpeed);
		
	void SetNextWaypoint(FVector NewWaypoint);
	
	void SetTarget(AActor* NewTarget);
	
	void ClearWaypoints();
	
	UFUNCTION(BlueprintCallable)
	void GetFlySpeed(float& OutSpeed);
	
	UFUNCTION(BlueprintCallable)
	float GetMaxFlySpeed();
	
	FVector GetNextWaypoint();
	
	UFUNCTION(BlueprintCallable)
	TArray<FVector> GetWaypoints();
	
protected:
	// Called when the game starts
	virtual void BeginPlay() override;

private:	
	// Called every frame
	
	float FlySpeed = 0.0f;
	
	UPROPERTY(EditAnywhere)
	float MaxFlySpeed = 0.0f;
	
	UPROPERTY(EditAnywhere)
	float RotationSpeed = 0.0f;
	
	UPROPERTY(EditAnywhere, Category="Movement")
	float Acceleration = 0.0f;

	UPROPERTY(EditAnywhere, Category="Movement")
	float Deceleration = 0.0f;

	UPROPERTY(EditAnywhere, Category="Movement")
	float ArrivalDistance = 50.0f;

	UPROPERTY(EditAnywhere, Category="Movement")
	float SlowdownDistance = 300.0f;
	
	UPROPERTY(EditAnywhere, Category="Movement")
	float ArrivalInaccuracyMargin = 300.0f;
	
	UPROPERTY(VisibleAnywhere)
	TArray<FVector> Waypoints;
	
	UPROPERTY(VisibleAnywhere)
	AActor* Target;
	
	void MoveShip(float DeltaTime);
	void RotateShip(float DeltaTime);
	void UpdateSpeed(float DeltaTime, float DistanceToTarget);
};
