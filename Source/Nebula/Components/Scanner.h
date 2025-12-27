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
	// Sets default values for this component's properties
	UScanner();
	
	UFUNCTION(BlueprintCallable)
	void Scan();
	
	UPROPERTY(VisibleAnywhere, BlueprintReadWrite)
	TArray<AActor*> EnemyObjects;
	
protected:
	virtual void BeginPlay() override;
	
private:
	UPROPERTY(EditAnywhere)
	USphereComponent* SphereComponent;
	
	UPROPERTY(EditAnywhere)
	float ScanRange;
	
	UPROPERTY(VisibleAnywhere)
	TArray<AActor*> FriendlyObjects;
	
	UPROPERTY(VisibleAnywhere)
	TArray<AActor*> NeutralObjects;
	
	
		
};
