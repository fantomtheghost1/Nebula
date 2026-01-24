// Fill out your copyright notice in the Description page of Project Settings.


#include "DockingComponent.h"

#include "CraftingComponent.h"
#include "../NebulaPlayerController.h"
#include "ResourceNodeComponent.h"
#include "SalvageComponent.h"
#include "TradingComponent.h"
#include "Blueprint/UserWidget.h"
#include "Components/SphereComponent.h"
#include "Nebula/Utils/NebulaLogging.h"

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
		}
		if (USalvageComponent* SalvageComponent = GetOwner()->FindComponentByClass<USalvageComponent>())
		{
			SalvageComponent->DockedFleet = DockedFleet;
		} 
		if (UCraftingComponent* CraftingComponent = GetOwner()->FindComponentByClass<UCraftingComponent>())
		{
			CraftingComponent->DockedFleet = DockedFleet;
		} 
		if (UTradingComponent* TradingComponent = GetOwner()->FindComponentByClass<UTradingComponent>())
		{
			TradingComponent->DockedFleet = DockedFleet;
		}
		UE_LOG(LogGameplay, Warning, TEXT("Docked %s"), *DockedFleet->GetName());
	}
}

void UDockingComponent::Interact(AFleet* InteractingFleet)
{
	return;
}

void UDockingComponent::ClearDockedFleets()
{
	DockedFleets.Empty();
}

void UDockingComponent::BeginPlay()
{
	Super::BeginPlay();
	
	SphereComp = GetOwner()->FindComponentByClass<USphereComponent>();
	if (SphereComp)
	{
		SphereComp->SetCollisionProfileName(TEXT("OverlapAllDynamic"));
		SphereComp->OnComponentBeginOverlap.AddDynamic(
			this,
			&UDockingComponent::OnOverlapBegin);
	} else
	{
		FMessageLog("PIE").Error(FText::FromString("Object Owner must have Sphere Collision."));
	}
	
	
}

void UDockingComponent::OnOverlapBegin(UPrimitiveComponent* OverlappedComp, AActor* OtherActor,
	UPrimitiveComponent* OtherComp, int32 OtherBodyIndex, bool bFromSweep, const FHitResult& SweepResult)
{
	UE_LOG(LogGameplay, Warning, TEXT("Docking Begin Overlap"));
	if (AFleet* DockingFleet = Cast<AFleet>(OtherActor))
	{
		UE_LOG(LogGameplay, Warning, TEXT("Docking Begin Overlap with %s"), *DockingFleet->GetName());
		if (DockingFleet->IsPlayerFleet)
		{
			UE_LOG(LogGameplay, Warning, TEXT("Docking Begin Overlap with Player"));
			Dock(true, DockingFleet);
		} else
		{
			UE_LOG(LogGameplay, Warning, TEXT("Docking Begin Overlap with AI"));
			Dock(false, DockingFleet);
		}
	}
}
