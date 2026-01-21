// Fill out your copyright notice in the Description page of Project Settings.

#include "Fleet.h"

#include "NebulaGameInstance.h"
#include "NebulaGameMode.h"
#include "Relay.h"
#include "Starbase.h"
#include "Kismet/GameplayStatics.h"
#include "Utils/NebulaLogging.h"

// Sets default values
AFleet::AFleet()
{
 	// Set this pawn to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;

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
	
	SphereComponent = CreateDefaultSubobject<USphereComponent>(TEXT("ScannerCollision"));
	SphereComponent->SetupAttachment(RootComponent);
	SphereComponent->SetCollisionProfileName(TEXT("OverlapAllDynamic"));
	SphereComponent->SetCollisionEnabled(ECollisionEnabled::QueryAndPhysics);
}

// Called when the game starts or when spawned
void AFleet::BeginPlay()
{
	Super::BeginPlay();
	
	if (IsPlayerFleet)
	{
		if (UFaction** Found = Cast<UNebulaGameInstance>(GetGameInstance())->Factions.Find(1))
		{
			Affiliation = *Found;
		}
	} else
	{
		if (UFaction** Found = Cast<UNebulaGameInstance>(GetGameInstance())->Factions.Find(2))
		{
			Affiliation = *Found;
		}
	}
}

// Called every frame
void AFleet::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);
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
			
			if (UDockingComponent* DockingComponent = HitResult.GetActor()->FindComponentByClass<UDockingComponent>())
			{
				DockingComponent->Interact(this);
			}
			else if (ARelay* Relay = Cast<ARelay>(HitResult.GetActor()))
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
