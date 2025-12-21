// Fill out your copyright notice in the Description page of Project Settings.


#include "Planet.h"

#include "GameFramework/RotatingMovementComponent.h"

// Sets default values
APlanet::APlanet()
{
	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;

	RootComponent = CreateDefaultSubobject<USceneComponent>(TEXT("Root"));

	MeshComponent = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("Mesh"));
	MeshComponent->SetupAttachment(RootComponent);
	
	MeshComponent->SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);
	MeshComponent->SetCollisionResponseToChannel(ECC_Visibility, ECollisionResponse::ECR_Block);

	RotatingMovementComponent = CreateDefaultSubobject<URotatingMovementComponent>(TEXT("Rotating Movement"));
	
	DockingComponent = CreateDefaultSubobject<UDockingComponent>(TEXT("Docking"));
	
}

// Called when the game starts or when spawned
void APlanet::BeginPlay()
{
	Super::BeginPlay();
	
	float NewRotation = FMath::FRandRange(-5.0f, 5.0f);
	FRotator NewRotationRate = FRotator(NewRotation, NewRotation, NewRotation);
	
	if (RotatingMovementComponent)
	{
		RotatingMovementComponent->RotationRate = NewRotationRate;
	}
}

// Called every frame
void APlanet::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);
}