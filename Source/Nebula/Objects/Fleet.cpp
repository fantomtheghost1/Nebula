// Fill out your copyright notice in the Description page of Project Settings.

#include "Fleet.h"

#include "../NebulaGameInstance.h"
#include "Relay.h"
#include "../Utils/NebulaLogging.h"

// Sets default values
AFleet::AFleet()
{
 	// Set this pawn to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;
	
	Tags.Add(FName(TEXT("Fleet")));

	RootComponent = CreateDefaultSubobject<USceneComponent>(TEXT("Root"));
	
	SpringArmComponent = CreateDefaultSubobject<USpringArmComponent>(TEXT("SpringArm"));
	SpringArmComponent->SetupAttachment(RootComponent);
	
	CameraComponent = CreateDefaultSubobject<UCameraComponent>(TEXT("Camera"));
	CameraComponent->SetupAttachment(SpringArmComponent);

	MeshComponent = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("Mesh"));
	MeshComponent->SetupAttachment(RootComponent);
	
	static ConstructorHelpers::FObjectFinder<UStaticMesh> CubeMesh(
		TEXT("/Engine/BasicShapes/Cube.Cube")
	);

	if (CubeMesh.Succeeded())
	{
		MeshComponent->SetStaticMesh(CubeMesh.Object);
	}
	
	Mover = CreateDefaultSubobject<UMoverComponent>(TEXT("Mover"));
	
	Cargo = CreateDefaultSubobject<UCargoComponent>(TEXT("Cargo"));
	
	ScannerComponent = CreateDefaultSubobject<UScanner>(TEXT("Scanner"));
	
	TextDisplay = CreateDefaultSubobject<UTextDisplayComponent>(TEXT("TextDisplay"));
	
	SphereComponent = CreateDefaultSubobject<USphereComponent>(TEXT("ScannerCollision"));
	SphereComponent->SetupAttachment(RootComponent);
	SphereComponent->SetCollisionProfileName(TEXT("OverlapAllDynamic"));
	SphereComponent->SetCollisionEnabled(ECollisionEnabled::QueryAndPhysics);
	SphereComponent->SetCollisionResponseToChannel(ECC_Visibility, ECR_Block);
}

// Called every frame
void AFleet::BeginPlay()
{
	Super::BeginPlay();
}

// Called to bind functionality to input
void AFleet::SetupPlayerInputComponent(UInputComponent* PlayerInputComponent)
{
	Super::SetupPlayerInputComponent(PlayerInputComponent);
}

void AFleet::DetermineInteract(FHitResult HitResult)
{
	if (HitResult.IsValidBlockingHit())
	{
		UE_LOG(LogGameplay, Warning, TEXT("Hit %s"), *HitResult.GetActor()->GetName());
		if (HitResult.GetActor()->ActorHasTag("Fightable") && HitResult.GetActor() != this)
		{
			UE_LOG(LogGameplay, Warning, TEXT("Fighting with %s"), *HitResult.GetActor()->GetName());
			UNebulaGameInstance* GI = Cast<UNebulaGameInstance>(GetGameInstance());
			if (GI)
			{
				AFleet* EnemyFleet = Cast<AFleet>(HitResult.GetActor());
				GI->StartBattle(this, EnemyFleet);
			}
		} 
		else {
			UE_LOG(LogGameplay, Warning, TEXT("Interacting with %s"), *HitResult.GetActor()->GetName());
			// If is click floor, move ship
			FVector NewLocation = FVector(HitResult.ImpactPoint.X, HitResult.ImpactPoint.Y, 0.0f);
			SetNewWaypoint(NewLocation);
			
			if (ARelay* Relay = Cast<ARelay>(HitResult.GetActor()))
			{
				Relay->Interact(this);
			}
		}
	}
}

void AFleet::SetNewWaypoint(FVector NewPosition)
{
	FindComponentByClass<UMoverComponent>()->ClearWaypoints();
	FindComponentByClass<UMoverComponent>()->SetNextWaypoint(NewPosition);
}

TArray<FShipData> AFleet::GetFleetData()
{
	return Fleet;
}
