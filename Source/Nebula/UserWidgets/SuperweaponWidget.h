// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Blueprint/UserWidget.h"
#include "Nebula/Objects/Superweapon.h"
#include "SuperweaponWidget.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API USuperweaponWidget : public UUserWidget
{
	GENERATED_BODY()
	
public: 
	UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Superweapon")
	ASuperweapon* Superweapon;
	
protected:
	virtual void NativeConstruct() override;
};
