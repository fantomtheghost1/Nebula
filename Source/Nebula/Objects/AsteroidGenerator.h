// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "Nebula/Components/SpawnRingsComponent.h"
#include "AsteroidGenerator.generated.h"

UCLASS()
class NEBULA_API AAsteroidGenerator : public AActor
{
	GENERATED_BODY()
	
public:
	AAsteroidGenerator();
	
	virtual void OnConstruction(const FTransform& Transform) override;
	
#if WITH_EDITOR
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent) override;
#endif
	
protected:
	virtual void BeginPlay() override;
		
	TObjectPtr<USpawnRingsComponent> SpawnRings = nullptr;
	
private:
	UPROPERTY(EditAnywhere, Category="Asteroid Generator")
	int MaxAttemptsPerAsteroid;
	
	UPROPERTY(EditAnywhere, Category="Asteroid Generator")
	int AsteroidCount;
	
	UPROPERTY(EditAnywhere, Category="Asteroid Generator")
	float RadiusMax;
	
	UPROPERTY(EditAnywhere, Category="Asteroid Generator")
	float RadiusMin;
	
	UPROPERTY(EditAnywhere, Category="Asteroid Generator")
	float ClearanceRadius;
	
	UPROPERTY(EditAnywhere, Category="Asteroid Generator")
	TArray<TSubclassOf<AActor>> AsteroidBlueprints;
	
	UPROPERTY(EditAnywhere, Category="Asteroid Generator")
    AActor* OrbitPoint;
};
