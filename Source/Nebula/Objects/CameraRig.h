// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Camera/CameraComponent.h"
#include "GameFramework/Pawn.h"
#include "GameFramework/SpringArmComponent.h"
#include "CameraRig.generated.h"

UCLASS()
class NEBULA_API ACameraRig : public AActor
{
	GENERATED_BODY()

public:
	// Sets default values for this pawn's properties
	ACameraRig();
	
	// Called every frame
	virtual void Tick(float DeltaTime) override;

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;

private:	
	UPROPERTY(EditAnywhere)
	AActor* Target;
	
	UPROPERTY(EditAnywhere)
	bool FollowTarget = false;
	
	UPROPERTY(VisibleAnywhere)
	USpringArmComponent* SpringArmComponent;

	UPROPERTY(VisibleAnywhere)
	UCameraComponent* CameraComponent;
};
