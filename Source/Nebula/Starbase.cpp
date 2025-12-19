// Fill out your copyright notice in the Description page of Project Settings.


#include "Starbase.h"

#include "NebulaPlayerController.h"
#include "Ship.h"
#include "Blueprint/UserWidget.h"

// Sets default values
AStarbase::AStarbase()
{
 	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;
	
	RootComp = CreateDefaultSubobject<USceneComponent>(TEXT("Root"));
	RootComponent = RootComp;

	MeshComp = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("Mesh"));
	MeshComp->SetupAttachment(RootComp);
	
	MeshComp->SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);
	MeshComp->SetCollisionResponseToChannel(ECC_Visibility, ECollisionResponse::ECR_Block);
}

// Called when the game starts or when spawned
void AStarbase::BeginPlay()
{
	Super::BeginPlay();
}

// Called every frame
void AStarbase::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);
}

void AStarbase::Interact()
{
	ANebulaPlayerController* PC = Cast<ANebulaPlayerController>(GetWorld()->GetFirstPlayerController());
	PC->SetInputDisabled(true);
	PC->GetShip()->FindComponentByClass<UStaticMeshComponent>()->SetVisibility(false);
	
	if (DockingUI)
	{
		DockingUIWidget = CreateWidget<UUserWidget>(GetWorld(), DockingUI);
		DockingUIWidget->AddToViewport();
	}
}