// Fill out your copyright notice in the Description page of Project Settings.


#include "Starbase.h"

#include "../NebulaGameInstance.h"

// Sets default values
AStarbase::AStarbase()
{
 	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;
	
	Tags.Add(FName(TEXT("Starbase")));
	
	RootComp = CreateDefaultSubobject<USceneComponent>(TEXT("Root"));
	RootComponent = RootComp;

	MeshComp = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("Mesh"));
	MeshComp->SetupAttachment(RootComp);
	
	MeshComp->SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);
	MeshComp->SetCollisionResponseToChannel(ECC_Visibility, ECollisionResponse::ECR_Block);
	
	SphereCollision = CreateDefaultSubobject<USphereComponent>(TEXT("SphereCollision"));
	SphereCollision->SetupAttachment(RootComponent);
	SphereCollision->SetSphereRadius(100.0f);
	
	DockingComponent = CreateDefaultSubobject<UDockingComponent>(TEXT("Docking"));
	
	OrbitComponent = CreateDefaultSubobject<UOrbitComponent>(TEXT("Orbit"));
	
	RotatingMovementComponent = CreateDefaultSubobject<URotatingMovementComponent>(TEXT("Rotating Movement"));
}

// Called when the game starts or when spawned
void AStarbase::BeginPlay()
{
	Super::BeginPlay();
	
	float NewRotation = FMath::FRandRange(RotationMin, RotationMax);
	FRotator NewRotationRate = FRotator(0.0f, NewRotation, 0.0f);
	
	if (RotatingMovementComponent)
	{
		RotatingMovementComponent->RotationRate = NewRotationRate;
	}
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

UFaction* AStarbase::GetAffiliation()
{
	return Affiliation;
}
