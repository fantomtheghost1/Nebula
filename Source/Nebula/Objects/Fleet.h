// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Faction.h"
#include "../Components/MoverComponent.h"
#include "GameFramework/Pawn.h"
#include "../DataStructs/ShipData.h"
#include "Camera/CameraComponent.h"
#include "../Components/CargoComponent.h"
#include "../Components/Scanner.h"
#include "Components/SphereComponent.h"
#include "GameFramework/SpringArmComponent.h"
#include "Nebula/Components/TextDisplayComponent.h"
#include "Nebula/DataStructs/Leader.h"
#include "Components/StaticMeshComponent.h"
#include "GameFramework/FloatingPawnMovement.h"
#include "Nebula/Components/FuelComponent.h"

class UDockingComponent;
#include "Fleet.generated.h"

UCLASS()
class NEBULA_API AFleet : public APawn
{
	GENERATED_BODY()

public:
	AFleet();

	virtual void SetupPlayerInputComponent(class UInputComponent* PlayerInputComponent) override;
	
	void DetermineInteract(FHitResult HitResult);
	
	UFUNCTION(BlueprintCallable)
	TArray<FShipData> GetFleetData();
	
	UFUNCTION(BlueprintCallable)
	void SetFleetData(TArray<FShipData> FleetDataParam);
	
	UPROPERTY(EditAnywhere)
	bool IsPlayerFleet;
	
	UPROPERTY(VisibleAnywhere, BlueprintReadWrite)
	AActor* DockedTo;
	
	UPROPERTY(VisibleAnywhere, BlueprintReadWrite)
	UFaction* Affiliation;
	
	UPROPERTY(EditAnywhere)
	USphereComponent* SphereComponent;
	
	UPROPERTY(EditAnywhere)
	FLeader Leader;
	
	UPROPERTY(BlueprintReadWrite)
	AActor* Home;

	UPROPERTY(BlueprintReadWrite)
	bool Docking = false;
	
protected:
	virtual void BeginPlay() override;
	
private:
	UPROPERTY(EditAnywhere)
	UStaticMeshComponent* MeshComponent;
	
	UPROPERTY(EditAnywhere)
	USpringArmComponent* SpringArmComponent;
	
	UPROPERTY(EditAnywhere)
	UCameraComponent* CameraComponent;
	
	UPROPERTY(EditAnywhere)
	UScanner* ScannerComponent;
	
	UPROPERTY(EditAnywhere)
	UDockingComponent* DockingComponent;
	
	UPROPERTY(EditAnywhere)
	UFloatingPawnMovement* MovementComponent;
	
	UPROPERTY(EditAnywhere)
	UFuelComponent* FuelComponent;
	
	UPROPERTY(EditAnywhere)
	TArray<FShipData> Fleet;
	
	UPROPERTY(EditAnywhere)
	UMoverComponent* Mover;
	
	UPROPERTY(EditAnywhere)
	UFuelComponent* Fuel;

	UPROPERTY(EditAnywhere)
	UCargoComponent* Cargo;

};

