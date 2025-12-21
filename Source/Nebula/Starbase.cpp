// Fill out your copyright notice in the Description page of Project Settings.


#include "Starbase.h"

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
	
	DockingComponent = CreateDefaultSubobject<UDockingComponent>(TEXT("Docking"));
	
	CargoComponent = CreateDefaultSubobject<UCargoComponent>(TEXT("Cargo"));
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

void AStarbase::Interact(AFleet* InteractingFleet)
{
	if (DockingComponent)
	{
		DockingComponent->Dock(true, InteractingFleet);
	}
}