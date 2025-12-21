// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Components/MoverComponent.h"
#include "Components/TurretComponent.h"
#include "Camera/CameraComponent.h"
#include "GameFramework/Pawn.h"
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
	
	void DetermineInteract(FHitResult HitResult);
	
	UPROPERTY(EditAnywhere)
	bool IsPlayerShip;
	
	/* SETTERS */
	void SetDocked(bool NewDocked);

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;

private:	
	UPROPERTY(EditAnywhere)
	UMoverComponent* Mover;

	UPROPERTY(EditAnywhere)
	UHealthComponent* Health;
	
	UPROPERTY(EditAnywhere)
	UTurretComponent* Turret;
	
	UPROPERTY(EditAnywhere)
	UStaticMeshComponent* MeshComponent;
	
	UPROPERTY(EditAnywhere)
	USpringArmComponent* SpringArmComponent;
	
	UPROPERTY(EditAnywhere)
	UCameraComponent* CameraComponent;
	
	UPROPERTY(VisibleAnywhere)
	AActor* Target;
};
