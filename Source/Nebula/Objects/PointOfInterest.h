// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Faction.h"
#include "Components/SphereComponent.h"
#include "GameFramework/Actor.h"
#include "Nebula/NebulaGameInstance.h"
#include "Nebula/Enums/PointOfInterestModifiers.h"
#include "PointOfInterest.generated.h"

UCLASS()
class NEBULA_API APointOfInterest : public AActor
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	APointOfInterest();
	
	void SetModifiers(TArray<EPointOfInterestModifiers> Modifiers);
	
	UFUNCTION()
	void OnBoxBeginOverlap(
		UPrimitiveComponent* OverlappedComponent,
		AActor* OtherActor,
		UPrimitiveComponent* OtherComp,
		int32 OtherBodyIndex,
		bool bFromSweep,
		const FHitResult& SweepResult
	);

	UFUNCTION()
	void OnBoxEndOverlap(
		UPrimitiveComponent* OverlappedComponent,
		AActor* OtherActor,
		UPrimitiveComponent* OtherComp,
		int32 OtherBodyIndex
	);
	
protected:
	
	virtual void BeginPlay() override;

private:	
	
	UFaction* Owner;
	
	UNebulaGameInstance* NGI;
	
	UPROPERTY(EditAnywhere)
	UStaticMeshComponent* MeshComp;
	
	UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="Components", meta=(AllowPrivateAccess="true"))
	USphereComponent* PointOfInterestBounds;
	
	UPROPERTY(EditAnywhere)
	float Radius;
	
	UPROPERTY(EditAnywhere)
	TArray<EPointOfInterestModifiers> Modifiers;
	
	TArray<EPointOfInterestModifiers> PresetModifiers;
};
