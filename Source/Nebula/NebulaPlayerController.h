// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Objects/Fleet.h"
#include "GameFramework/PlayerController.h"
#include "InputActionValue.h"
#include "Objects/Ship.h"
#include "Camera/CameraComponent.h"
#include "GameFramework/SpringArmComponent.h"
#include "Objects/CameraRig.h"
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
	
	UPROPERTY(EditAnywhere, Category = "Input")
	UInputAction* InventoryAction;
	
	UPROPERTY(EditAnywhere, Category = "Input")
	UInputAction* TabAction;
	
	UPROPERTY(EditAnywhere, Category = "Input")
    UInputAction* ConstructionAction;
	
public:
	
	void TogglePaused();
	
	void UpdateZoom(const FInputActionValue& ZoomNormalized);
	
	void Interact();
	
	void Construct();
	
	void ToggleInventory();
	
	void ToggleTabMenu();
	
	UFUNCTION(BlueprintCallable)
	bool GetInputDisabled();
	
	UFUNCTION(BlueprintCallable)
	void SetInputDisabled(bool InputDisabled);
	
	UFUNCTION(BlueprintCallable)
	void SetWaypointsDisabled(bool WaypointsDisabled);
	
	UFUNCTION(BlueprintCallable)
	AFleet* GetFleet();

	/* ORBIT FUNCTIONS */
	
	void StartOrbit();
	 
	void EndOrbit();
	
	void SetOrbitAmount(const FInputActionValue& MouseXY);
	
	void RegisterCamera(ACameraRig* NewCameraPawn);
	
	UPROPERTY(EditAnywhere, BlueprintReadWrite)
	int Credits;
	
	UPROPERTY(EditAnywhere, Category = "Spawning")
	TSubclassOf<AActor> ConstructionClass;

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
	
	UPROPERTY(EditAnywhere, Category = "UI")
	TSubclassOf<UUserWidget> InventoryWidgetClass;
	
	UUserWidget* InventoryWidget;
	
	UPROPERTY(EditAnywhere, Category = "UI")
	TSubclassOf<UUserWidget> TabMenuWidgetClass;
	
	UPROPERTY(EditAnywhere, Category = "UI")
	TSubclassOf<UUserWidget> PauseWidgetClass;
	
	UUserWidget* PauseWidget;
	
	UUserWidget* TabMenuWidget;
	
	ACameraRig* CameraRig;
	
	USpringArmComponent* SpringArm;
	
	AFleet* Fleet;
	
	AShip* Ship;
	
	float OrbitAmount;
	
	bool Inventory = false;
	
	bool FleetComp = false;
	
	bool Orbit = false;
	
	bool DisableInput = false;
	
	bool DisableWaypoints = false;
};
