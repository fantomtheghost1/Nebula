// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "Nebula/NebulaGameMode.h"
#include "Nebula/Enums/SystemEffects.h"
#include "SystemEffectHandler.generated.h"

UCLASS()
class NEBULA_API ASystemEffectHandler : public AActor
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	ASystemEffectHandler();

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;

private:	
	
	void ActivateEffect();
	
	void StartEffectTimer();
	
	UPROPERTY(EditAnywhere, Category="Effect")
	ESystemEffects Effect;
	
	UPROPERTY(EditAnywhere, Category="Effect")
	float EffectDuration;
	
	UPROPERTY(EditAnywhere, Category="Effect")
	float EffectInterval;
	
	UPROPERTY(EditAnywhere, Category="Effect", meta=(EditCondition="Effect == ESystemEffects::SolarFlare", EditConditionHides))
	float SlowdownPercent;
	
	ANebulaGameMode* GameMode;

	FTimerHandle EffectTimer;
	FTimerHandle EffectIntervalTimer;
};
