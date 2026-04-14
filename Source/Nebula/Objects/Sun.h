// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "GameFramework/RotatingMovementComponent.h"
#include "Nebula/Components/OrbitComponent.h"
#include "Sun.generated.h"

UCLASS()
class NEBULA_API ASun : public AActor
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	ASun();

private:
	UPROPERTY(EditAnywhere)
	UStaticMeshComponent* MeshComponent;
	
	UPROPERTY(EditAnywhere)
	URotatingMovementComponent* RotatingMovementComponent;
	
	UPROPERTY(EditAnywhere)
	UOrbitComponent* OrbitComponent;
};
