// Fill out your copyright notice in the Description page of Project Settings.


#include "FogOfWarComponent.h"

#include "Nebula/NebulaPlayerController.h"

// Sets default values for this component's properties
UFogOfWarComponent::UFogOfWarComponent()
{
	// Set this component to be initialized when the game starts, and to be ticked every frame.  You can turn these features
	// off to improve performance if you don't need them.
	PrimaryComponentTick.bCanEverTick = true;
}


// Called when the game starts
void UFogOfWarComponent::BeginPlay()
{
	Super::BeginPlay();

	if (UMeshComponent* Mesh = GetOwner()->FindComponentByClass<UMeshComponent>())
	{
		
		MaterialInstance = UMaterialInstanceDynamic::Create(FadeMaterial, Mesh);
		if (MaterialInstance)
		{
			Mesh->SetMaterial(0, MaterialInstance);
		}
	}
	
	
}


// Called every frame
void UFogOfWarComponent::TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction)
{
	Super::TickComponent(DeltaTime, TickType, ThisTickFunction);

	if (ANebulaPlayerController* NPC = GetWorld()->GetFirstPlayerController()->GetPawn()->GetController<ANebulaPlayerController>())
	{
		FVector PlayerLocation = NPC->GetFleet()->GetActorLocation();
		FVector OwnerLocation = GetOwner()->GetActorLocation();
		MaterialInstance->SetVectorParameterValue("Direction", (OwnerLocation - PlayerLocation).GetSafeNormal());
		
		float DistanceBetweenLocations = (OwnerLocation - PlayerLocation).Size();
		float FadeAmount = 0.0f;

		if (DistanceBetweenLocations <= FullyVisibleRadius)
		{
			FadeAmount = -1.0f;
		}
		else if (DistanceBetweenLocations >= FullyHiddenRadius)
		{
			FadeAmount = 1.0f;
		}
		else
		{
			float T = (DistanceBetweenLocations - FullyVisibleRadius) / (FullyHiddenRadius - FullyVisibleRadius);
			FadeAmount = FMath::Lerp(-1.0f, 1.0f, T);
		}
		
		MaterialInstance->SetScalarParameterValue("Fade Amount", FadeAmount);
	}
	

}

