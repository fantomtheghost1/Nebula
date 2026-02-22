// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Components/SphereComponent.h"
#include "GameFramework/Actor.h"
#include "GasPocket.generated.h"

UCLASS()
class NEBULA_API AGasPocket : public AActor
{
	GENERATED_BODY()
	
public:
	AGasPocket();
	
private:
	UPROPERTY(EditAnywhere)
	USphereComponent* SphereComponent;
};
