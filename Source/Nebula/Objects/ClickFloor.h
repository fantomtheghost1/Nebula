// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "ClickFloor.generated.h"

UCLASS()
class NEBULA_API AClickFloor : public AActor
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	AClickFloor();
	
	void SetFloorSize(FVector Size);
	
	void SetVisible(bool Visible);

private:
	UPROPERTY(VisibleAnywhere)
	UStaticMeshComponent* MeshComponent;

};
