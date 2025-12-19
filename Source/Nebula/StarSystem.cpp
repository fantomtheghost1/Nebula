// Fill out your copyright notice in the Description page of Project Settings.


#include "StarSystem.h"
#include "Kismet/KismetMathLibrary.h"

// Sets default values
AStarSystem::AStarSystem()
{
 	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;
	
	SpawnBox = CreateDefaultSubobject<UBoxComponent>(TEXT("SpawnBox"));
	RootComponent = SpawnBox;
}

void AStarSystem::OnConstruction(const FTransform& Transform)
{
	Super::OnConstruction(Transform);
	
	SpawnBox->SetBoxExtent(FVector(SpawnAreaX * 2, SpawnAreaY * 2, 100.0f));
}

// Called when the game starts or when spawned
void AStarSystem::BeginPlay()
{
	Super::BeginPlay();
	
	// Asteroid Spawning Logic
	FVector Extent = SpawnBox->GetScaledBoxExtent();
	FVector Origin = SpawnBox->GetComponentLocation();
	
	for (int i = 0; i < MaxAsteroids; i++)
	{
		FVector RandomPoint = UKismetMathLibrary::RandomPointInBoundingBox(Origin, Extent);
		RandomPoint.Z = 10.0f;
		
		AAsteroid* Ast = GetWorld()->SpawnActor<AAsteroid>(AsteroidClass, RandomPoint, FRotator::ZeroRotator);
		if (!Ast)
			UE_LOG(LogTemp, Warning, TEXT("Failed to spawn asteroid at %s"), *RandomPoint.ToString());
	}
	
}

// Called every frame
void AStarSystem::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);
}

void AStarSystem::AddShipToSystem(AShip* Ship)
{
	ShipsInSystem.Add(Ship);
}

void AStarSystem::GetShipsInSystem(TArray<AShip*>& OutShips)
{
	OutShips = ShipsInSystem;
}

