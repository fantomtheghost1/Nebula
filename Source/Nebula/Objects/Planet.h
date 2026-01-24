// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "../Components/DockingComponent.h"
#include "Components/SphereComponent.h"
#include "GameFramework/Actor.h"
#include "GameFramework/RotatingMovementComponent.h"
#include "Planet.generated.h"

UCLASS()
class NEBULA_API APlanet : public AActor
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	APlanet();
	
	// Called every frame
	virtual void Tick(float DeltaTime) override;

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;
	
private:
	UPROPERTY(VisibleAnywhere)
	UStaticMeshComponent* MeshComponent;
	
	UPROPERTY(VisibleAnywhere)
	URotatingMovementComponent* RotatingMovementComponent;
	
	UPROPERTY(VisibleAnywhere)
	USphereComponent* SphereCollision;
	
	UPROPERTY(VisibleAnywhere)
	UDockingComponent* DockingComponent;
};
