// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "SpawnZone.generated.h"

UCLASS()
class NEBULA_API ASpawnZone : public AActor
{
	GENERATED_BODY()

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;
	
private:
	
	void Spawn();
	
	UPROPERTY(EditAnywhere)
	TSubclassOf<AActor> SpawnActor;
	
	UPROPERTY(EditAnywhere)
	float Size;
	
	UPROPERTY(EditAnywhere)
	float SpawnRate;
	
	FTimerHandle SpawnTimer;

};
