// Fill out your copyright notice in the Description page of Project Settings.


#include "Asteroid.h"
#include "GameFramework/RotatingMovementComponent.h"

// Sets default values
AAsteroid::AAsteroid()
{
 	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;

	RootComponent = CreateDefaultSubobject<USceneComponent>(TEXT("Root"));

	MeshComponent = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("Mesh"));
	MeshComponent->SetupAttachment(RootComponent);

	RotatingMovementComponent = CreateDefaultSubobject<URotatingMovementComponent>(TEXT("Rotating Movement Component"));
}

// Called when the game starts or when spawned
void AAsteroid::BeginPlay()
{
	Super::BeginPlay();
	
	float NewRotation = FMath::FRandRange(-17.0f, 17.0f);
	FRotator NewRotationRate = FRotator(NewRotation, NewRotation, NewRotation);
	RotatingMovementComponent->RotationRate = NewRotationRate;

}

// Called every frame
void AAsteroid::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);
}

