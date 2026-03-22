// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "Nebula/Components/DockingComponent.h"
#include "Nebula/Enums/Superweapons.h"
#include "Superweapon.generated.h"

UCLASS()
class NEBULA_API ASuperweapon : public AActor
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	ASuperweapon();
	
	UFUNCTION(BlueprintCallable)
	void Fire();
	
private:
	UPROPERTY(EditAnywhere)
	ESuperweapons WeaponType;

	UPROPERTY(EditAnywhere)
	UStaticMeshComponent* MeshComponent;
	
	UPROPERTY(EditAnywhere)
	UDockingComponent* DockingComponent;
	
	UPROPERTY(EditAnywhere)
	USphereComponent* SphereComponent;
	
	AActor* GetClosestTarget(TSubclassOf<AActor> TargetClass, FName Tag = "");
};
