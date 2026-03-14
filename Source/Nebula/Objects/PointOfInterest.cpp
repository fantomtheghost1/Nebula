// Fill out your copyright notice in the Description page of Project Settings.


#include "PointOfInterest.h"
#include "Nebula/NebulaGameInstance.h"
#include "Nebula/Subsystems/GalaxyManagerSubsystem.h"
#include "Nebula/Subsystems/PointsOfInterestSubsystem.h"

// Sets default values
APointOfInterest::APointOfInterest()
{
	RootComponent = CreateDefaultSubobject<USceneComponent>(TEXT("RootComponent"));
		
	PointOfInterestBounds = CreateDefaultSubobject<USphereComponent>(TEXT("PointOfInterestBounds"));
	PointOfInterestBounds->SetupAttachment(RootComponent);
	PointOfInterestBounds->SetCollisionEnabled(ECollisionEnabled::QueryOnly);
	PointOfInterestBounds->SetGenerateOverlapEvents(true);
	
	MeshComp = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("Mesh"));
	MeshComp->SetupAttachment(RootComponent);
	MeshComp->SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

	PointOfInterestBounds->OnComponentBeginOverlap.AddDynamic(this, &APointOfInterest::OnBoxBeginOverlap);
	PointOfInterestBounds->OnComponentEndOverlap.AddDynamic(this, &APointOfInterest::OnBoxEndOverlap);
}

void APointOfInterest::SetModifiers(TArray<EPointOfInterestModifiers> NewModifiers)
{
	UE_LOG(LogTemp, Log, TEXT("Setting %s Modifier"), *UEnum::GetValueAsString(NewModifiers[0]));
	Modifiers = NewModifiers;
	
	for (int i = 0; i < Modifiers.Num(); i++)
	{
		UE_LOG(LogTemp, Log, TEXT("Modifier %i: %s"), i, *UEnum::GetValueAsString(Modifiers[i]));
	}
}

void APointOfInterest::BeginPlay()
{
	Super::BeginPlay();
	
	PresetModifiers = Modifiers;
	
	if (Radius <= 0) Radius = 100.f;
	PointOfInterestBounds->SetSphereRadius(Radius);
	
	NGI = Cast<UNebulaGameInstance>(GetWorld()->GetGameInstance());
	if (!NGI) return;
	NGI->GetSubsystem<UPointsOfInterestSubsystem>()->RegisterPOI(this);
	UE_LOG(LogTemp, Log, TEXT("Registered POI %s"), *GetName());
}

void APointOfInterest::OnBoxBeginOverlap(
	UPrimitiveComponent* OverlappedComponent,
	AActor* OtherActor,
	UPrimitiveComponent* OtherComp,
	int32 OtherBodyIndex,
	bool bFromSweep,
	const FHitResult& SweepResult)
{
	if (!OtherActor || OtherActor == this) return;
	
	AFleet* CollidingFleet = Cast<AFleet>(OtherActor);
	if (!CollidingFleet) return;

	NGI->GetSubsystem<UGalaxyManagerSubsystem>()->TriggerModifier(this);
	UE_LOG(LogTemp, Log, TEXT("Triggering Modifier"));
}

void APointOfInterest::OnBoxEndOverlap(
	UPrimitiveComponent* OverlappedComponent,
	AActor* OtherActor,
	UPrimitiveComponent* OtherComp,
	int32 OtherBodyIndex)
{
	if (!OtherActor || OtherActor == this) return;
	
	AFleet* CollidingFleet = Cast<AFleet>(OtherActor);
	if (!CollidingFleet) return;

	Modifiers = PresetModifiers;
	UE_LOG(LogTemp, Log, TEXT("Reverting Modifier"));
}