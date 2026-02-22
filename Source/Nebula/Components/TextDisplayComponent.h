// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Components/ActorComponent.h"
#include "Components/TextRenderComponent.h"
#include "TextDisplayComponent.generated.h"


UCLASS( ClassGroup=(Custom), meta=(BlueprintSpawnableComponent) )
class NEBULA_API UTextDisplayComponent : public UActorComponent
{
	GENERATED_BODY()

public:	
	// Sets default values for this component's properties
	UTextDisplayComponent();
	
	// Called every frame
	virtual void TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction) override;

protected:
	// Called when the game starts
	virtual void BeginPlay() override;

private:
	void InitializeTextRender();
	
	void SetText();
	
	void SetFlyingText();
	
	void SetPlanetText();
	
	void SetAsteroidText();
	
	void SetStarbaseText();
	
	UTextRenderComponent* TextRender;
	
	UPROPERTY(EditAnywhere)
	float VerticalOffset;
};
