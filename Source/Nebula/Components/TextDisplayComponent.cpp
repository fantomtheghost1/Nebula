// Fill out your copyright notice in the Description page of Project Settings.


#include "TextDisplayComponent.h"

#include "Kismet/GameplayStatics.h"
#include "Nebula/NebulaGameInstance.h"
#include "Nebula/Subsystems/LeaderSubsystem.h"
#include "Nebula/Utils/NebulaLogging.h"

// Sets default values for this component's properties
UTextDisplayComponent::UTextDisplayComponent()
{
	// Set this component to be initialized when the game starts, and to be ticked every frame.  You can turn these features
	// off to improve performance if you don't need them.
	PrimaryComponentTick.bCanEverTick = true;
}

// Called when the game starts
void UTextDisplayComponent::BeginPlay()
{
	Super::BeginPlay();
	
	InitializeTextRender();
	
	SetText();
}

void UTextDisplayComponent::InitializeTextRender()
{
	if (AActor* Owner = GetOwner())
	{
		if (USceneComponent* RootComponent = Owner->GetRootComponent())
		{
			TextRender = NewObject<UTextRenderComponent>(GetOwner(), TEXT("Text Render"));
			if (!TextRender) return;
			
			TextRender->RegisterComponent();
			TextRender->AttachToComponent(RootComponent, FAttachmentTransformRules::KeepRelativeTransform);
			TextRender->SetTextRenderColor(FColor::Orange);
			TextRender->SetWorldScale3D(FVector(4.0f));
			TextRender->SetRelativeLocation(FVector(0.0f, 0.0f, VerticalOffset));
		}
	}
}

void UTextDisplayComponent::SetText()
{
	if (!TextRender) return;
	
	if (GetOwner()->ActorHasTag("Fleet") || GetOwner()->ActorHasTag("Ship"))
		SetFlyingText();
	else if (GetOwner()->ActorHasTag("Planet"))
		SetPlanetText();
	else if (GetOwner()->ActorHasTag("Asteroid"))
		SetAsteroidText();
	else if (GetOwner()->ActorHasTag("Starbase"))
		SetStarbaseText();
}

void UTextDisplayComponent::SetFlyingText()
{
	UNebulaGameInstance* GI = Cast<UNebulaGameInstance>(GetWorld()->GetGameInstance());
	if (GI)
	{
		AFleet* OwningObject = Cast<AFleet>(GetOwner());
		if (OwningObject->IsPlayerFleet)
		{
			OwningObject->Leader = GI->PlayerLeader;
			TextRender->SetText(FText::FromString(OwningObject->Leader.LeaderName.ToString()));
			UE_LOG(LogGameplay, Warning, TEXT("Player %s Leader Created!"), *OwningObject->Leader.LeaderName.ToString());
		} else
		{
			ULeaderSubsystem* LeaderSubsystem = GI->GetSubsystem<ULeaderSubsystem>();
			if (LeaderSubsystem)
			{
				OwningObject->Leader = LeaderSubsystem->GenerateLeader();
				TextRender->SetText(FText::FromString(OwningObject->Leader.LeaderName.ToString()));
				UE_LOG(LogGameplay, Warning, TEXT("Enemy %s Leader Created!"), *OwningObject->Leader.LeaderName.ToString());
			}
		}
	}
}

void UTextDisplayComponent::SetPlanetText()
{
	APlanet* OwningPlanet = Cast<APlanet>(GetOwner());
	if (OwningPlanet)
	{
		TextRender->SetText(FText::FromString(OwningPlanet->PlanetName.ToString()));
	}
}

void UTextDisplayComponent::SetAsteroidText()
{
	AAsteroid* OwningAsteroid = Cast<AAsteroid>(GetOwner());
	if (OwningAsteroid)
	{
		UResourceNodeComponent* ResourceNodeComponent = OwningAsteroid->FindComponentByClass<UResourceNodeComponent>();
		if (ResourceNodeComponent)
		{
			TextRender->SetText(FText::FromString(ResourceNodeComponent->GetResourceName().ToString()));
		}
	}
}

void UTextDisplayComponent::SetStarbaseText()
{
	AStarbase* OwningStarbase = Cast<AStarbase>(GetOwner());
	if (OwningStarbase)
	{
		TextRender->SetText(FText::FromString(OwningStarbase->GetAffiliation()->GetName().ToString()));
	}
}

// Called every frame
void UTextDisplayComponent::TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction)
{
	Super::TickComponent(DeltaTime, TickType, ThisTickFunction);

	if (!TextRender)
	{
		return;
	}

	APlayerController* PC = UGameplayStatics::GetPlayerController(this, 0);
	if (!PC || !PC->PlayerCameraManager)
	{
		return;
	}

	const FVector CamLoc = PC->PlayerCameraManager->GetCameraLocation();
	const FVector TextLoc = TextRender->GetComponentLocation();

	// Point the text at the camera, but only rotate around Z (stay upright)
	const FRotator LookAt = (CamLoc - TextLoc).Rotation();
	const FRotator YawOnly(LookAt.Pitch, LookAt.Yaw, 0.0f);

	TextRender->SetWorldRotation(YawOnly);
}

