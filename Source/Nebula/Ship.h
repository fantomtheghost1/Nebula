// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Pawn.h"
#include "InputActionValue.h"
#include "Camera/CameraComponent.h"
#include "GameFramework/SpringArmComponent.h"

#include "Ship.generated.h"

UCLASS()
class NEBULA_API AShip : public APawn
{
	GENERATED_BODY()

public:
	// Sets default values for this pawn's properties
	AShip();
	
	// Called every frame
	virtual void Tick(float DeltaTime) override;

	// Called to bind functionality to input
	virtual void SetupPlayerInputComponent(class UInputComponent* PlayerInputComponent) override;
	
	void ClearWaypoints();
	
	void DetermineInteract(FHitResult HitResult);
	
	/* SETTERS */
	void SetFlySpeed(float NewSpeed);
		
	void SetNextWaypoint(FVector NewWaypoint);
	
	/* GETTERS */
	void GetFlySpeed(float& OutSpeed);
	
	FVector GetNextWaypoint();
	
	TArray<FVector> GetWaypoints();

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;

private:	
	
	UPROPERTY(EditAnywhere)
	float FlySpeed = 0.0f;
	
	UPROPERTY(EditAnywhere, Category = "Health")
	float MaxHullPoints;
	
	UPROPERTY(VisibleAnywhere, Category = "Health")
	float HullPoints;
	
	UPROPERTY(EditAnywhere, Category = "Health")
	float MaxShieldPoints;
	
	UPROPERTY(VisibleAnywhere, Category = "Health")
	float ShieldPoints;
	
	UPROPERTY(EditAnywhere)
	float TurretDamage;
	
	UPROPERTY(EditAnywhere)
	float TurretFireRate;
	
	UPROPERTY(EditAnywhere)
	int NumOfTurrets;
	
	UPROPERTY(EditAnywhere)
	bool IsMiner;
	
	UPROPERTY(VisibleAnywhere)
	AActor* Target;
	
	UPROPERTY(VisibleAnywhere)
	TArray<FVector> Waypoints;
	
	UPROPERTY(EditAnywhere)
	bool Owned = false;
};
