// Fill out your copyright notice in the Description page of Project Settings.


#include "Ship.h"

#include "Components/MoverComponent.h"
#include "Components/TurretComponent.h"

// Sets default values
AShip::AShip()
{
 	// Set this pawn to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;
	Tags.Add(FName(TEXT("CombatTarget")));
	Tags.Add(FName(TEXT("Targetable")));
	
	RootComponent = CreateDefaultSubobject<USceneComponent>(TEXT("Root"));

	MeshComponent = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("Mesh"));
	MeshComponent->SetupAttachment(RootComponent);
	
	SpringArmComponent = CreateDefaultSubobject<USpringArmComponent>(TEXT("SpringArm"));
	SpringArmComponent->SetupAttachment(RootComponent);
	
	CameraComponent = CreateDefaultSubobject<UCameraComponent>(TEXT("Camera"));
	CameraComponent->SetupAttachment(SpringArmComponent);
	
	Mover = CreateDefaultSubobject<UMoverComponent>(TEXT("Mover"));
	
	Health = CreateDefaultSubobject<UHealthComponent>(TEXT("Health"));
	
	Turret = CreateDefaultSubobject<UTurretComponent>(TEXT("Turret"));
}

// Called when the game starts or when spawned
void AShip::BeginPlay()
{
	Super::BeginPlay();
}

// Called every frame
void AShip::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);
}

// Called to bind functionality to input
void AShip::SetupPlayerInputComponent(UInputComponent* PlayerInputComponent)
{
	Super::SetupPlayerInputComponent(PlayerInputComponent);
}

void AShip::DetermineInteract(FHitResult HitResult)
{
	if (HitResult.IsValidBlockingHit())
	{
		if (HitResult.GetActor()->ActorHasTag("Targetable") && HitResult.GetActor() != this)
		{
			FindComponentByClass<UTurretComponent>()->SetTarget(HitResult.GetActor());
		} 
		else {
			// If is click floor, move ship
			FVector NewLocation = FVector(HitResult.ImpactPoint.X, HitResult.ImpactPoint.Y, 0.0f);
			FindComponentByClass<UMoverComponent>()->ClearWaypoints();
			FindComponentByClass<UMoverComponent>()->SetNextWaypoint(NewLocation);
		}
	}
}