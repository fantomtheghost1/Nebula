// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "Asteroid.generated.h"

class URotatingMovementComponent;

UCLASS()
class NEBULA_API AAsteroid : public AActor
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	AAsteroid();
	
	// Called every frame
	virtual void Tick(float DeltaTime) override;
	
	UPROPERTY(VisibleAnywhere)
	UStaticMeshComponent* MeshComponent;
	
	UPROPERTY(VisibleAnywhere)
	URotatingMovementComponent* RotatingMovementComponent;
	
	UPROPERTY(EditAnywhere)
	float OreMax;
	
	UPROPERTY(VisibleAnywhere)
	float Ore;

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;
	
	//test
	
};
