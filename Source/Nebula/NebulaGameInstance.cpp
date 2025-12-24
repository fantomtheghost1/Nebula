// Fill out your copyright notice in the Description page of Project Settings.


#include "NebulaGameInstance.h"

#include "EngineUtils.h"
#include "Faction.h"
#include "NebulaGameMode.h"
#include "Kismet/GameplayStatics.h"

void UNebulaGameInstance::StartBattle(AFleet* PlayerFleet, AFleet* AIFleet)
{
	UpdateState();
	
	PlayerFleetData = PlayerFleet->GetFleetData();
	AIFleetData = AIFleet->GetFleetData();
	
	OpposingFleetID = GetFleetID(AIFleet);
	PlayerFleetID = GetFleetID(PlayerFleet);
	
	ANebulaGameMode* GM = Cast<ANebulaGameMode>(UGameplayStatics::GetGameMode(this));
	GM->InitializeBattle(PlayerFleetData.Num(), AIFleetData.Num());
	
	UGameplayStatics::OpenLevel(this, FName("BattleSpace"));
}

void UNebulaGameInstance::EndBattle(bool PlayerWon)
{
	UGameplayStatics::OpenLevel(this, FName("Main"));
	
	if (PlayerWon)
	{
		Fleets.Remove(OpposingFleetID);
	} else
	{
		Fleets.Remove(PlayerFleetID);
	}
}

void UNebulaGameInstance::UpdateState()
{
	for (TActorIterator<AFleet> ActorItr(GetWorld()); ActorItr; ++ActorItr)
	{
		FFleetState NewFleetState;
		NewFleetState.Location = ActorItr->GetActorLocation();
		NewFleetState.Rotation = ActorItr->GetActorRotation();
		NewFleetState.FleetData = ActorItr->GetFleetData();
		NewFleetState.IsPlayer = ActorItr->IsPlayerFleet;
		
		Fleets.Emplace(ActorItr->GetUniqueID(), NewFleetState);
	}
}

int UNebulaGameInstance::GetFleetID(AFleet* Fleet)
{
	for (const TPair<int, FFleetState>& Elem : Fleets)
	{
		if (Elem.Value.FleetData == Fleet->GetFleetData()) return Elem.Key;
	}
	return -1;
}

void UNebulaGameInstance::Init()
{
	Super::Init();
	
	UFaction* PlayerFaction = NewObject<UFaction>(this);
	PlayerFaction->SetName("Player");
	PlayerFaction->SetColor(FColor::Blue);
	
	Factions.Add(1, PlayerFaction);
	
	UFaction* AIFaction = NewObject<UFaction>(this);
	AIFaction->SetName("AI");
    AIFaction->SetColor(FColor::Red);
	
	Factions.Add(2, AIFaction);
}
