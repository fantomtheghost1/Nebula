// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "Components/CargoComponent.h"
#include "Components/DockingComponent.h"
#include "Components/SphereComponent.h"
#include "Salvage.generated.h"

UCLASS()
class NEBULA_API ASalvage : public AActor
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	ASalvage();

private:	

	UPROPERTY(EditAnywhere)
	UStaticMeshComponent* MeshComponent;
	
	UPROPERTY(EditAnywhere)
	UDockingComponent* DockingComponent;
	
	UPROPERTY(EditAnywhere)
	UCargoComponent* Resources;
	
	UPROPERTY(EditAnywhere)
	USalvageComponent* SalvageComponent;
	
	UPROPERTY(VisibleAnywhere)
	USphereComponent* SphereCollision;
};
