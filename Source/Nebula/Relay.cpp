
// Fill out your copyright notice in the Description page of Project Settings.


#include "Relay.h"

// Sets default values
ARelay::ARelay()
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
void ARelay::BeginPlay()
{
	Super::BeginPlay();
}

// Called every frame
void ARelay::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);
}

void ARelay::Interact(AShip* TravelingShip)
{
	if (Connection)
	{
		TravelingShip->SetActorLocation(Connection->GetActorLocation());
	}
}

