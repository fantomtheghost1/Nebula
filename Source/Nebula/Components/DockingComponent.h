// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "../Objects/Fleet.h"
#include "Components/ActorComponent.h"
#include "Components/SphereComponent.h"
#include "DockingComponent.generated.h"	

UCLASS( ClassGroup=(Custom), meta=(BlueprintSpawnableComponent) )
class NEBULA_API UDockingComponent : public UActorComponent
{
	GENERATED_BODY()

public:	
	
	void Dock(bool IsPlayer, AFleet* DockedFleet);
	
	void Interact(AFleet* InteractingFleet);
	
	UUserWidget* DockingUIWidget;
	
	UFUNCTION(BlueprintCallable)
	void ClearDockedFleets();
	
protected:
	
	virtual void BeginPlay() override;
	
private:
	UFUNCTION()
	void OnOverlapBegin(
		UPrimitiveComponent* OverlappedComp, 
		AActor* OtherActor, 
		UPrimitiveComponent* OtherComp,
		int32 OtherBodyIndex,
		bool bFromSweep,
		const FHitResult& SweepResult);
	
	UPROPERTY(EditAnywhere)
	TSubclassOf<UUserWidget> DockingUI;
	
	UPROPERTY(EditAnywhere)
	int DockLimit;
	
	UPROPERTY(VisibleAnywhere)
	TArray<AFleet*> DockedFleets;
	
	USphereComponent* SphereComp;
	
	bool IsResourceNode = false;
};
