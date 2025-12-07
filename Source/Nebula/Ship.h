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
	
	/* GETTERS AND SETTERS */
	void SetFlySpeed(float NewSpeed);
	
	void GetFlySpeed(float& OutSpeed);
	
	void SetZoom(const FInputActionValue& ZoomNormalized);
	
	UFUNCTION(BlueprintCallable, Category = "Zoom")
	float GetZoom();


protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;

private:	
	
	void UpdateCameraRotation();
	
	UPROPERTY(EditAnywhere)
	float FlySpeed = 0.0f;
	
	
	/* ZOOM VARIABLES */
	UPROPERTY(EditAnywhere, Category = "Zoom")
	float ZoomSpeed = 0.0f;
	
	UPROPERTY(EditAnywhere, Category = "Zoom")
	float ZoomMax = 0.0f;
	
	UPROPERTY(EditAnywhere, Category = "Zoom")
	float ZoomMin = 0.0f;
	
	USpringArmComponent* SpringArm;
	
	UCameraComponent* Camera;
};
