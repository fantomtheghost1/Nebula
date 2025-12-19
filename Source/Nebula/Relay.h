// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
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
	
	void Interact(AShip* TravelingShip);

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;
	
private:
	
	UPROPERTY(EditAnywhere)
	AStarSystem* Connection;
	
	USceneComponent* RootComp;
	
	UPROPERTY(VisibleAnywhere)
	UStaticMeshComponent* MeshComp;
};
