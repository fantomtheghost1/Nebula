// Fill out your copyright notice in the Description page of Project Settings.

#include "NebulaGameMode.h"

#include "NebulaGameInstance.h"
#include "Utils/NebulaLogging.h"

// test
void ANebulaGameMode::BeginPlay()
{
	Super::BeginPlay();
	
	GameInstance = Cast<UNebulaGameInstance>(GetGameInstance());
	FactionSubsystem = GameInstance->GetSubsystem<UFactionSubsystem>();
	
	if (!TraderBlueprint) return;
	GetWorld()->GetTimerManager().SetTimer(
		TraderSpawnTimer,
		this,
		&ANebulaGameMode::SpawnTradeFleet,
		TraderSpawnInterval,
		true,
		0.0f
	);
}

void ANebulaGameMode::InitializeBattle(int NewPlayerShipCount, int NewAIShipCount)
{
	AIShipCount = NewAIShipCount;
	PlayerShipCount = NewPlayerShipCount;
}

void ANebulaGameMode::RegisterFleet(AFleet* NewFleet)
{
	Fleets.Add(NewFleet);
}

void ANebulaGameMode::RegisterStarbase(AStarbase* NewStarbase)
{
	Starbases.Add(NewStarbase);
}

AStarbase* ANebulaGameMode::GetRandomStarbase()
{
	if (Starbases.Num() > 0)
	{
		int32 RandomIndex = FMath::RandRange(0, Starbases.Num() - 1);
		AStarbase* Starbase = Starbases[RandomIndex];
		return Starbase;
	}
	return nullptr;
}

TArray<AFleet*> ANebulaGameMode::GetFleets()
{
	return Fleets;
}

void ANebulaGameMode::SubtractAIShip()
{
	AIShipCount--;
	
	if (AIShipCount <= 0)
	{
		AIShipCount = 0;
		GameInstance->EndBattle(false);
	}
}

void ANebulaGameMode::SubtractPlayerShip()
{
	PlayerShipCount--;
	
	if (PlayerShipCount <= 0)
	{
		PlayerShipCount = 0;
		GameInstance->EndBattle(true);
	}
}

void ANebulaGameMode::CheckVictoryCondition()
{
	if (FactionSubsystem->GetNumberOfFactions() <= 1)
	{
		UE_LOG(LogGameplay, Warning, TEXT("Victory Condition Met!"));
		StartGame();
	}
}

void ANebulaGameMode::SpawnTradeFleet()
{
	AStarbase* Starbase = GetRandomStarbase();
	if (!Starbase) return;
	
	if (GetWorld() && SpawnTraders)
	{
		AFleet* NewTrader = GetWorld()->SpawnActor<AFleet>(TraderBlueprint, Starbase->GetActorLocation(), Starbase->GetActorRotation());
		NewTrader->Home = Starbase;
		Starbase->GetComponentByClass<UDockingComponent>()->Dock(false, NewTrader);
	}
}

AFleet* ANebulaGameMode::GetPlayerFleet()
{
	for (int i = 0; i < Fleets.Num(); i++)
	{
		if (Fleets[i]->IsPlayerFleet)
		{
			return Fleets[i];
		}
	}
	return nullptr;
}

void ANebulaGameMode::StartGame()
{
	FactionSubsystem->ClearFactions();
	GameInstance->StartGame();
	
	GameInstance->Systems.Empty();
	GameInstance->Fleets.Empty();
	GameInstance->Asteroids.Empty();
	GameInstance->Planets.Empty();
	GameInstance->Starbases.Empty();
}

void ANebulaGameMode::EndGame()
{
	GameInstance->StartGame();
}
