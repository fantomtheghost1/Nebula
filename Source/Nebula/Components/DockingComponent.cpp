// Fill out your copyright notice in the Description page of Project Settings.


#include "DockingComponent.h"

#include "DialogComponent.h"
#include "../NebulaPlayerController.h"
#include "ResourceNodeComponent.h"
#include "SalvageComponent.h"
#include "Components/SphereComponent.h"
#include "Nebula/Objects/Relay.h"
#include "Nebula/Objects/Fleet.h"
#include "Nebula/Objects/Superweapon.h"
#include "Nebula/UserWidgets/SuperweaponWidget.h"
#include "Nebula/Utils/NebulaLogging.h"

UDockingComponent::UDockingComponent()
{
	PrimaryComponentTick.bCanEverTick = true;
}

void UDockingComponent::TickComponent(float DeltaTime, ELevelTick TickType,
                                      FActorComponentTickFunction* ThisTickFunction)
{
	Super::TickComponent(DeltaTime, TickType, ThisTickFunction);
	
	if (IsPlayerDocked)
	{
		ANebulaPlayerController* PC = Cast<ANebulaPlayerController>(GetWorld()->GetFirstPlayerController());
		PC->GetFleet()->SetActorLocation(GetOwner()->GetActorLocation());
		PC->GetCameraRig()->SetActorLocation(GetOwner()->GetActorLocation());
		PC->SetDockedCamera();
	}
}

void UDockingComponent::Dock(bool IsPlayer, AFleet* DockedFleet)
{
	if (DockedFleets.Num() < DockLimit)
	{
		
		if (GetOwner()->IsA<AFleet>())
		{
			if (GetOwner()->Tags.Contains(TEXT("Fightable"))) return;
			AFleet* Fleet = Cast<AFleet>(GetOwner());
			if (Fleet) {
				TArray<FShipData> NewFleetData = Fleet->GetFleetData();
				for (int i = 0; i < DockedFleet->GetFleetData().Num(); i++)
				{
					NewFleetData.Add(DockedFleet->GetFleetData()[i]);
				}
				Fleet->SetFleetData(NewFleetData);
			}
			
		}
		if (UResourceNodeComponent* ResourceNodeComponent = GetOwner()->FindComponentByClass<UResourceNodeComponent>())
		{
			ResourceNodeComponent->DockedFleet = DockedFleet;
		}
		if (USalvageComponent* SalvageComponent = GetOwner()->FindComponentByClass<USalvageComponent>())
		{
			SalvageComponent->DockedFleet = DockedFleet;
		} 
		if (UDialogComponent* DialogComponent = GetOwner()->FindComponentByClass<UDialogComponent>())
		{
			DialogComponent->StartDialogue();
		}
		if (GetOwner()->ActorHasTag(TEXT("Relay")))
		{
			ARelay* Relay = Cast<ARelay>(GetOwner());
			Relay->DockedFleet = DockedFleet;
			Relay->Interact();
		}
		UE_LOG(LogGameplay, Warning, TEXT("Docked %s"), *DockedFleet->GetName());
		
		CreateDockingWidget(IsPlayer);
		if (IsPlayer)
		{
			IsPlayerDocked = true;
		}
		
		DockedFleets.Add(DockedFleet);
		DockedFleet->DockedTo = GetOwner();
	}
}

void UDockingComponent::ClearDockedFleets()
{
	DockedFleets.Empty();
	
	ANebulaPlayerController* PC = Cast<ANebulaPlayerController>(GetWorld()->GetFirstPlayerController());
	PC->SetInputDisabled(false);
	PC->GetFleet()->SetActorHiddenInGame(false);
	IsPlayerDocked = false;
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
		UE_LOG(LogGameplay, Warning, TEXT("Docking Begin Overlap with Player"));
		Dock(DockingFleet->IsPlayerFleet, DockingFleet);
	}
}

void UDockingComponent::CreateDockingWidget(bool IsPlayer)
{
	if (IsPlayer)
	{
		ANebulaPlayerController* PC = Cast<ANebulaPlayerController>(GetWorld()->GetFirstPlayerController());
		PC->SetInputDisabled(true);
		PC->GetFleet()->SetActorHiddenInGame(true);

		if (DockingUI)
		{
			DockingUIWidget = CreateWidget<UUserWidget>(GetWorld(), DockingUI);
			if (USuperweaponWidget* Widget = Cast<USuperweaponWidget>(DockingUIWidget))
			{
				Widget->Superweapon = Cast<ASuperweapon>(GetOwner());
			}
			DockingUIWidget->AddToViewport();
		}
	}
}
