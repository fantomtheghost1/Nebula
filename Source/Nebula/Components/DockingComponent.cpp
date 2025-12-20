// Fill out your copyright notice in the Description page of Project Settings.


#include "DockingComponent.h"

#include "../NebulaPlayerController.h"
#include "ResourceNodeComponent.h"
#include "Blueprint/UserWidget.h"

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
		
		if (UResourceNodeComponent* ResourceNodeComponent = GetOwner()->FindComponentByClass<UResourceNodeComponent>())
		{
			ResourceNodeComponent->DockedFleet = DockedFleet;
		} else if (USalvageComponent* SalvageComponent = GetOwner()->FindComponentByClass<USalvageComponent>())
		{
			SalvageComponent->DockedFleet = DockedFleet;
		}
	}
}

void UDockingComponent::Interact(AFleet* InteractingFleet)
{
	Dock(true, InteractingFleet);
}