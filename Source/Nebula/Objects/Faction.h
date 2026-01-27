// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "UObject/Object.h"
#include "Faction.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API UFaction : public UObject
{
	GENERATED_BODY()
	
public:
	
	UFaction();
	
	void RegisterMember(AActor* NewMember);
	
	void DeregisterMember(AActor* NewMember);
	
	void SetName(FName NewName);
	
	void SetColor(FColor NewColor);
	
	TArray<AActor*> GetMembers();
	
	FName GetName();
	
	FColor GetColor();
	
private:
	
	UPROPERTY(EditAnywhere, Category="Faction")
	FName Name;
	
	UPROPERTY(EditAnywhere, Category="Faction")
	FColor Color;
	
	UPROPERTY(VisibleAnywhere, Category="Faction")
	TArray<AActor*> Members;
	
};
