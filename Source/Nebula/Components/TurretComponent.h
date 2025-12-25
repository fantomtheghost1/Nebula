// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "HealthComponent.h"
#include "Components/ActorComponent.h"
#include "TurretComponent.generated.h"


UCLASS( ClassGroup=(Custom), meta=(BlueprintSpawnableComponent) )
class NEBULA_API UTurretComponent : public UActorComponent
{
	GENERATED_BODY()

public:	
	// Sets default values for this component's properties
	UTurretComponent();
	
	virtual void TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction) override;
	
	void SetTarget(AActor* NewTarget);
	
	UFUNCTION(BlueprintCallable)
	int GetDamage();

protected:
	// Called when the game starts
	virtual void BeginPlay() override;

private:	
	// Called every frame
	void Fire();
	
	UPROPERTY(EditAnywhere)
	float TurretDamage;
	
	UPROPERTY(EditAnywhere)
	float TurretFireRate;
	
	UPROPERTY(EditAnywhere)
	int NumOfTurrets;
	
	FTimerHandle FireTimerHandle;
	
	UPROPERTY(VisibleAnywhere)
	AActor* Target;
	
	UPROPERTY(VisibleAnywhere)
	UHealthComponent* TargetHealthComp;
};
