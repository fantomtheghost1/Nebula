// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Components/ActorComponent.h"
#include "OrbitComponent.generated.h"


UCLASS( ClassGroup=(Custom), meta=(BlueprintSpawnableComponent) )
class NEBULA_API UOrbitComponent : public UActorComponent
{
	GENERATED_BODY()

public:	
	UOrbitComponent();
	
	virtual void TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction) override;
	
private:
	
	void RotateAroundPivot(FVector PivotLocation);
	
	UPROPERTY(EditAnywhere)
	AActor* PivotActor;
		
	UPROPERTY(EditAnywhere)
	float RotationRate;
};
