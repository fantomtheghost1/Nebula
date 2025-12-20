// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "../Fleet.h"
#include "Components/ActorComponent.h"
#include "DockingComponent.generated.h"


UCLASS( ClassGroup=(Custom), meta=(BlueprintSpawnableComponent) )
class NEBULA_API UDockingComponent : public UActorComponent
{
	GENERATED_BODY()

public:	
	// Sets default values for this component's properties
	UDockingComponent();
	
	// Called every frame
	virtual void TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction) override;

	void Dock(bool IsPlayer, AFleet* DockedFleet);

protected:
	// Called when the game starts
	virtual void BeginPlay() override;
	
private:
	
	UPROPERTY(EditAnywhere)
	TSubclassOf<UUserWidget> DockingUI;
	
	UPROPERTY(EditAnywhere)
	int DockLimit;
	
	UPROPERTY(VisibleAnywhere)
	TArray<AFleet*> DockedFleets;
	
	bool IsResourceNode = false;
	
	UUserWidget* DockingUIWidget;
};
