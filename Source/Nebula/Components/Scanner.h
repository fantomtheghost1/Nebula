// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Components/ActorComponent.h"
#include "Components/SphereComponent.h"
#include "Scanner.generated.h"


UCLASS( ClassGroup=(Custom), meta=(BlueprintSpawnableComponent) )
class NEBULA_API UScanner : public UActorComponent
{
	GENERATED_BODY()

public:	
	
	UFUNCTION(BlueprintCallable)
	void Scan();
	
	UPROPERTY(VisibleAnywhere, BlueprintReadWrite)
	TArray<AActor*> FriendlyObjects;
	
	UPROPERTY(VisibleAnywhere, BlueprintReadWrite)
	TArray<AActor*> NeutralObjects;
	
	UPROPERTY(VisibleAnywhere, BlueprintReadWrite)
	TArray<AActor*> EnemyObjects;
	
	UPROPERTY(EditAnywhere)
	float ScanRange;
	
protected:
	virtual void BeginPlay() override;
	
private:
	UPROPERTY(VisibleAnywhere)
	USphereComponent* SphereComponent;
};
