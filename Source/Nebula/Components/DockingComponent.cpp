// Fill out your copyright notice in the Description page of Project Settings.


#include "DockingComponent.h"

#include "../NebulaPlayerController.h"
#include "ResourceNodeComponent.h"
#include "Blueprint/UserWidget.h"

// Sets default values for this component's properties
UDockingComponent::UDockingComponent()
{
	PrimaryComponentTick.bCanEverTick = true;
}


// Called when the game starts
void UDockingComponent::BeginPlay()
{
	Super::BeginPlay();
	if (GetOwner()->FindComponentByClass<UResourceNodeComponent>())
	{
		DockLimit = 1;
		IsResourceNode = true;
	}
}


// Called every frame
void UDockingComponent::TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction)
{
	Super::TickComponent(DeltaTime, TickType, ThisTickFunction);
}

void UDockingComponent::Dock(bool IsPlayer, AFleet* DockedFleet)
{
	if (DockedFleets.Num() < DockLimit)
	{
		if (IsPlayer)
		{
			ANebulaPlayerController* PC = Cast<ANebulaPlayerController>(GetWorld()->GetFirstPlayerController());
			PC->SetInputDisabled(true);
			PC->GetFleet()->FindComponentByClass<UStaticMeshComponent>()->SetVisibility(false);

			if (DockingUI)
			{
				DockingUIWidget = CreateWidget<UUserWidget>(GetWorld(), DockingUI);
				DockingUIWidget->AddToViewport();
			}
		}
		
		DockedFleets.Add(DockedFleet);
		DockedFleet->DockedTo = GetOwner();
		
		GetOwner()->FindComponentByClass<UResourceNodeComponent>()->DockingComponent = this;
		GetOwner()->FindComponentByClass<UResourceNodeComponent>()->DockedFleet = DockedFleet;
	}
}

