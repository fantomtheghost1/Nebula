// Fill out your copyright notice in the Description page of Project Settings.


#include "FactionSubsystem.h"
#include "Nebula/NebulaGameInstance.h"

void UFactionSubsystem::Initialize(FSubsystemCollectionBase& Collection)
{
	Super::Initialize(Collection);
	
	AddFaction(FName("The Fivefold Mandate"), FColor::Yellow);
	AddFaction(FName("The Remnant"), FColor::Black);
	AddFaction(FName("The Helix Group"), FColor::Green);
}

UFaction* UFactionSubsystem::AddFaction(FName Name, FColor Color)
{
	UFaction* NewFaction = NewObject<UFaction>(this);
	NewFaction->SetName(Name);
	NewFaction->SetColor(Color);
	
	Factions.Add(Factions.Num() + 1, NewFaction);
	
	for (const TPair<int32, UFaction*>& Elem : Factions)
	{
		if (Elem.Value)
		{
			Elem.Value->AddFactionDiplomacy(NewFaction);
			NewFaction->AddFactionDiplomacy(Elem.Value);
		}
	}
	
	return NewFaction;
}

void UFactionSubsystem::RemoveFaction(FName Name)
{
	for (const TPair<int, UFaction*>& Elem : Factions)
	{
		if (Elem.Value->GetName() == Name)
		{
			Factions.Remove(Elem.Key);
		}
	}
}

UFaction* UFactionSubsystem::GetFactionByName(FName Name)
{
	for (const TPair<int, UFaction*>& Elem : Factions)
	{
		if (Elem.Value->GetName() == Name) return Elem.Value;
	}
	return nullptr;
}

void UFactionSubsystem::RegisterMemberByName(FName Name, AActor* Member)
{
	UFaction* Faction = GetFactionByName(Name);
	if (Faction)
	{
		Faction->RegisterMember(Member);
	} else
	{
		AddFaction(Name, FColor::White);
	}

}

int UFactionSubsystem::GetNumberOfFactions()
{
	return Factions.Num();
}

void UFactionSubsystem::ClearFactions()
{
	Factions.Empty();
}