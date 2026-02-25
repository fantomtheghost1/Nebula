// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Fleet.h"
#include "StarSystem.h"
#include "Ship.h"
#include "GameFramework/Actor.h"
#include "Relay.generated.h"

UCLASS()
class NEBULA_API ARelay : public AActor
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	ARelay();
	
	// Called every frame
	virtual void Tick(float DeltaTime) override;
	
	void Interact();
	
	UPROPERTY(EditAnywhere)
	AFleet* DockedFleet;

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;
	
private:
	
	void Warp();
	
	UPROPERTY(EditAnywhere)
	FName Connection;
	
	USceneComponent* RootComp;
	
	UPROPERTY(VisibleAnywhere)
	UStaticMeshComponent* MeshComp;
	
	UPROPERTY(EditAnywhere)
	USphereComponent* SphereCollision;
	
	UPROPERTY(EditAnywhere)
	float WarpDelay;
	
	FTimerHandle WarpTimer;
};
