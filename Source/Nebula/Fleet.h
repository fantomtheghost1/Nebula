// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Components/MoverComponent.h"
#include "GameFramework/Pawn.h"
#include "DataStructs/ShipData.h"
#include "Camera/CameraComponent.h"
#include "Components/CargoComponent.h"
#include "GameFramework/SpringArmComponent.h"
#include "Fleet.generated.h"

UCLASS()
class NEBULA_API AFleet : public APawn
{
	GENERATED_BODY()

public:
	// Sets default values for this pawn's properties
	AFleet();
	
	// Called every frame
	virtual void Tick(float DeltaTime) override;

	// Called to bind functionality to input
	virtual void SetupPlayerInputComponent(class UInputComponent* PlayerInputComponent) override;
	
	void DetermineInteract(FHitResult HitResult);
	
	UFUNCTION(BlueprintCallable)
	TArray<FShipData> GetFleetData();
	
	UPROPERTY(VisibleAnywhere, BlueprintReadWrite)
	AActor* DockedTo;

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;
	
private:
	UPROPERTY(EditAnywhere)
	UStaticMeshComponent* MeshComponent;
	
	UPROPERTY(EditAnywhere)
	USpringArmComponent* SpringArmComponent;
	
	UPROPERTY(EditAnywhere)
	UCameraComponent* CameraComponent;
	
	UPROPERTY(EditAnywhere)
	TArray<FShipData> Fleet;
	
	UPROPERTY(EditAnywhere)
	UMoverComponent* Mover;

	UPROPERTY(EditAnywhere)
	UCargoComponent* Cargo;
};