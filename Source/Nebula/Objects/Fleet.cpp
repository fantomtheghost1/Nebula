#include "Fleet.h"
#include "AIController.h"
#include "NavigationSystem.h"
#include "../NebulaGameInstance.h"
#include "../Utils/NebulaLogging.h"
#include "Kismet/GameplayStatics.h"
#include "../Components/DockingComponent.h"
#include "Nebula/NebulaGameMode.h"
#include "Engine/Engine.h"

// Sets default values
AFleet::AFleet()
{
 	// Set this pawn to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;
	
	Tags.Add(FName(TEXT("Fleet")));

	RootComponent = CreateDefaultSubobject<USceneComponent>(TEXT("Root"));
	RootComponent->SetMobility(EComponentMobility::Type::Movable);

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
	
	Fuel = CreateDefaultSubobject<UFuelComponent>(TEXT("Fuel"));
	
	ScannerComponent = CreateDefaultSubobject<UScanner>(TEXT("Scanner"));
	
	DockingComponent = CreateDefaultSubobject<UDockingComponent>(TEXT("Docking"));
	
	MovementComponent = CreateDefaultSubobject<UFloatingPawnMovement>(TEXT("FloatingPawnMovement"));
	
	SphereComponent = CreateDefaultSubobject<USphereComponent>(TEXT("ScannerCollision"));
	SphereComponent->SetupAttachment(RootComponent);
	SphereComponent->SetCollisionProfileName(TEXT("OverlapAllDynamic"));
	SphereComponent->SetCollisionEnabled(ECollisionEnabled::QueryAndPhysics);
	SphereComponent->SetCollisionResponseToChannel(ECC_Visibility, ECR_Block);

	AutoPossessAI = EAutoPossessAI::PlacedInWorldOrSpawned;
	AIControllerClass = AAIController::StaticClass();
}

// Called every frame
void AFleet::BeginPlay()
{
	Super::BeginPlay();
	
	AGameModeBase* GM = UGameplayStatics::GetGameMode(GetWorld());
	if (!GM) return;
	
	ANebulaGameMode* NGM = Cast<ANebulaGameMode>(GM);
	if (NGM)
	{
		NGM->RegisterFleet(this);
	}
}

// Called to bind functionality to input
void AFleet::SetupPlayerInputComponent(UInputComponent* PlayerInputComponent)
{
	Super::SetupPlayerInputComponent(PlayerInputComponent);
}

void AFleet::SetFleetData(TArray<FShipData> FleetDataParam)
{
	Fleet = FleetDataParam;
}

void AFleet::DetermineInteract(FHitResult HitResult)
{
	if (!HitResult.IsValidBlockingHit() || !HitResult.GetActor())
	{
		return;
	}

	UE_LOG(LogGameplay, Warning, TEXT("Hit %s"), *HitResult.GetActor()->GetName());

	if (HitResult.GetActor()->ActorHasTag("Fightable") && HitResult.GetActor() != this)
	{
		UE_LOG(LogGameplay, Warning, TEXT("Fighting with %s"), *HitResult.Component->GetName());
		UNebulaGameInstance* GI = Cast<UNebulaGameInstance>(GetGameInstance());
		if (GI)
		{
			AFleet* EnemyFleet = Cast<AFleet>(HitResult.GetActor());
			GI->StartBattle(this, EnemyFleet);
		}
	}
	else if (HitResult.GetActor()->ActorHasTag("ClickFloor"))
	{
		const FVector DesiredLocation = HitResult.ImpactPoint;

		UNavigationSystemV1* NavSys = UNavigationSystemV1::GetCurrent(GetWorld());
		if (!NavSys)
		{
			return;
		}

		FNavLocation ProjectedLocation;
		if (NavSys->ProjectPointToNavigation(DesiredLocation, ProjectedLocation))
		{
			if (AAIController* FleetController = Cast<AAIController>(GetController()))
			{
				GEngine->AddOnScreenDebugMessage(
					-1,
					5.0f,
					FColor::Yellow,
					FString::Printf(TEXT("Moving Fleet to %s"), *ProjectedLocation.Location.ToString())
				);
				
				Mover->MoveToLocation(ProjectedLocation.Location, FleetController);
			}
		}
	}
	else
	{
		FindComponentByClass<UMoverComponent>()->SetTarget(HitResult.GetActor());
	}
}

TArray<FShipData> AFleet::GetFleetData()
{
	return Fleet;
}
