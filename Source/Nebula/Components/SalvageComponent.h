// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Components/ActorComponent.h"
#include "Nebula/Fleet.h"
#include "SalvageComponent.generated.h"


UCLASS( ClassGroup=(Custom), meta=(BlueprintSpawnableComponent) )
class NEBULA_API USalvageComponent : public UActorComponent
{
	GENERATED_BODY()

public:	

	UFUNCTION(BlueprintCallable)
	void StartSalvage();
	
	void SalvageComplete();
	
	UPROPERTY(VisibleAnywhere)
	AFleet* DockedFleet;

private:
	
	UPROPERTY(EditAnywhere)
	float SalvageDuration;
	
	FTimerHandle SalvageTimer;
};
