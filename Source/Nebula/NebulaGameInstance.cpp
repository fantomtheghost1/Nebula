// Fill out your copyright notice in the Description page of Project Settings.


#include "NebulaGameInstance.h"

#include "EngineUtils.h"
#include "DataStructs/Leader.h"
#include "NebulaGameMode.h"
#include "NebulaPlayerController.h"
#include "Kismet/GameplayStatics.h"
#include "Subsystems/ContractSubsystem.h"
#include "Subsystems/FactionSubsystem.h"
#include "Subsystems/ScenarioSubsystem.h"
#include "Subsystems/SkillSubsystem.h"
#include "Utils/NebulaLogging.h"

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

void UNebulaGameInstance::StartGame()
{
	UGameplayStatics::OpenLevel(this, FName("Main"));
	
	UStartingScenarioAsset* Scenario = GetSubsystem<UScenarioSubsystem>()->GetScenarioByID(0);
	
	PlayerLeader.LeaderName = "Player";
	
	UFactionSubsystem* FactionSubsystem = GetSubsystem<UFactionSubsystem>();
	FName FactionName = FName(StaticEnum<EFactions>()->GetNameStringByValue(static_cast<int64>(Scenario->StartingFaction)));
	PlayerLeader.LeaderFaction = FactionSubsystem->GetFactionByName(FactionName);
	
	UFaction* Yellow = FactionSubsystem->GetFactionByName("Yellow");
	if (Yellow)
	{
		PlayerLeader.LeaderFaction->SetDiplomacy(Yellow, EDiplomacyStates::ALLY);
		UE_LOG(LogTemp, Warning, TEXT("Yellow Diplomacy Status: %s"), *StaticEnum<EDiplomacyStates>()->GetNameStringByValue(static_cast<int64>(PlayerLeader.LeaderFaction->GetDiplomacy(Yellow))));
	}
	
	UContractSubsystem* ContractSubsystem = GetSubsystem<UContractSubsystem>();
	ContractSubsystem->AddContract(FContractData("Test Contract", 100, EContractType::BOUNTY));
	
	FContractData* Contract = ContractSubsystem->GetContract(0);
	UE_LOG(LogTemp, Warning, TEXT("Contract: %s"), *Contract->ContractText);
	
	USkillSubsystem* SkillSubsystem = GetSubsystem<USkillSubsystem>();
	SkillSubsystem->AddSkillPoint();
}

void UNebulaGameInstance::Init()
{
	Super::Init();
	
	StartGame();
}
