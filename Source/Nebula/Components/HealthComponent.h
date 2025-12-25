// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Components/ActorComponent.h"
#include "HealthComponent.generated.h"

DECLARE_DYNAMIC_MULTICAST_DELEGATE_OneParam(FDamageTaken, int32, DamageAmount);

UCLASS( ClassGroup=(Custom), meta=(BlueprintSpawnableComponent, BlueprintReadWrite) )
class NEBULA_API UHealthComponent : public UActorComponent
{
	GENERATED_BODY()

public:	
	// Sets default values for this component's properties
	UHealthComponent();
	
	UPROPERTY(BlueprintAssignable, Category="Events")
	FDamageTaken DamageTaken;
	
	virtual void TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction) override;

	void TakeDamage(float DamageAmount);
	
	void Heal(float HealAmount);
	
	bool IsDead();
	
	UFUNCTION(BlueprintCallable)
	float GetHullPercent();
	
	UFUNCTION(BlueprintCallable)
	float GetShieldPercent();
	
	float GetMaxHull();
	
	float GetMaxShield();
	
	UFUNCTION(BlueprintCallable)
	void InitHealth(float NewMaxHull, float NewMaxShield);
	
protected:
	virtual void BeginPlay() override;

private:	
	// Called every frame
	UPROPERTY(EditAnywhere, Category = "Health")
	float MaxHull;
	
	UPROPERTY(VisibleAnywhere, Category = "Health")
	float Hull;
	
	UPROPERTY(EditAnywhere, Category = "Health")
	float MaxShield;
	
	UPROPERTY(VisibleAnywhere, Category = "Health")
	float Shield;
	
	UPROPERTY(VisibleAnywhere, Category = "Health")
	bool Dead = false;
	
	UPROPERTY(EditAnywhere)
	TSubclassOf<UUserWidget> DamageNumberWidget;
	
	UPROPERTY(EditAnywhere, Category = "Health")
	TSubclassOf<AActor> DamageNumberActor;
};
