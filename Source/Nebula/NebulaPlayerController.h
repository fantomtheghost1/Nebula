// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/PlayerController.h"
#include "InputActionValue.h"
#include "Ship.h"
#include "NebulaPlayerController.generated.h"

/**
 * 
 */
class UInputMappingContext;
class UInputAction;

UCLASS()
class NEBULA_API ANebulaPlayerController : public APlayerController
{
	GENERATED_BODY()
	
protected:
	
	virtual void BeginPlay() override;
	
	UPROPERTY(EditAnywhere, Category = "Input")
	UInputMappingContext* DefaultMappingContext;
	
	UPROPERTY(EditAnywhere, Category = "Input")
	UInputAction* ZoomAction;
	
	UPROPERTY(EditAnywhere, Category = "Input")
	UInputAction* QuitAction;
	
	UPROPERTY(EditAnywhere, Category = "Input")
	UInputAction* InteractAction;
	
	UPROPERTY(EditAnywhere, Category = "Input")
    UInputAction* AltAction;
	
	UPROPERTY(EditAnywhere, Category = "Input")
	UInputAction* OrbitAction;
	
	UPROPERTY(EditAnywhere, Category = "Input")
	UInputAction* LockAction;
	
public:
	// Called every frame
	virtual void Tick(float DeltaTime) override;
	
	void Quit();
	
	void UpdateZoom(const FInputActionValue& ZoomNormalized);
	
	void Interact();
	
	UFUNCTION(BlueprintCallable)
	void SetInputDisabled(bool InputDisabled);
	
	UFUNCTION(BlueprintCallable)
	AShip* GetShip();

	/* ORBIT FUNCTIONS */
	
	void StartOrbit();
	 
	void EndOrbit();
	
	void SetOrbitAmount(const FInputActionValue& MouseXY);

private:
	
	/* CAMERA VARIABLES */
	UPROPERTY(EditAnywhere, Category = "Camera")
	float ZoomSpeed = 0.0f;
	
	UPROPERTY(EditAnywhere, Category = "Camera")
	float ZoomMax = 0.0f;
	
	UPROPERTY(EditAnywhere, Category = "Camera")
	float ZoomMin = 0.0f;
	
	UPROPERTY(EditAnywhere, Category = "Camera")
	float OrbitRate = 0.0f;
	
	UPROPERTY(EditAnywhere, Category = "Camera")
	bool Idle = false;
	
	UPROPERTY(EditAnywhere, Category = "Camera")
	AActor* CameraTarget;
	
	UCameraComponent* Camera;
	
	USpringArmComponent* SpringArm;
	
	TArray<AShip*> Fleet;
	
	AShip* Ship;
	
	float OrbitAmount;
	
	bool Orbit = false;
	
	bool DisableInput = false;
};
