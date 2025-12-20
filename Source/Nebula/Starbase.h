// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Components/DockingComponent.h"
#include "GameFramework/Actor.h"
#include "Starbase.generated.h"

UCLASS()
class NEBULA_API AStarbase : public AActor
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	AStarbase();

	virtual void Tick(float DeltaTime) override;
	
	void Interact(AFleet* InteractingFleet);
	
protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;
	
private:
	
	UPROPERTY(EditAnywhere)
	FString Type;
	
	USceneComponent* RootComp;
	
	UPROPERTY(VisibleAnywhere)
	UStaticMeshComponent* MeshComp;
	
	UPROPERTY(VisibleAnywhere)
	UDockingComponent* DockingComponent;
	
	UPROPERTY(EditAnywhere)
	TSubclassOf<class UUserWidget> DockingUI;
	
	UUserWidget* DockingUIWidget;
};
