// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Engine/GameInstance.h"
#include "NebulaGameInstance.generated.h"

/**
 * 
 */
//class IOnlineSessionPtr;

UCLASS()
class NEBULA_API UNebulaGameInstance : public UGameInstance
{
	GENERATED_BODY()

protected:
	// Called when the game starts or when spawned
	virtual void Init() override;
	
private:
	 //IOnlineSessionPtr SessionInterface;
};
