// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Subsystems/GameInstanceSubsystem.h"
#include "SkillSubsystem.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API USkillSubsystem : public UGameInstanceSubsystem
{
	GENERATED_BODY()

public:
	UFUNCTION(BlueprintCallable)
	void AddSpeedFactor(float NewSpeedFactor);
	
	UFUNCTION(BlueprintCallable)
	float GetSpeedFactor();
	
	UFUNCTION(BlueprintCallable)
	void AddSkillPoint();
	
	UFUNCTION(BlueprintCallable)
	void SubtractSkillPoint();
	
	UFUNCTION(BlueprintCallable)
	int GetSkillPoints();
	
private:
	int SkillPoints;
	float SpeedFactor = 1;
};
