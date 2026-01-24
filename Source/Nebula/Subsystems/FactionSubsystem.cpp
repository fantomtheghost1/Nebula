// Fill out your copyright notice in the Description page of Project Settings.


#include "FactionSubsystem.h"

#include "Nebula/NebulaGameInstance.h"

UFaction* UFactionSubsystem::AddFaction(FString Name, FColor Color)
{
	UFaction* NewFaction = NewObject<UFaction>(this);
	NewFaction->SetName(Name);
	NewFaction->SetColor(Color);
	
	Factions.Add(Factions.Num() + 1, NewFaction);
	
	return NewFaction;
}

void UFactionSubsystem::RemoveFaction(FString Name)
{
	for (const TPair<int, UFaction*>& Elem : Factions)
	{
		if (Elem.Value->GetName() == Name)
		{
			Factions.Remove(Elem.Key);
		}
	}
}

UFaction* UFactionSubsystem::GetFactionByName(FString Name)
{
	for (const TPair<int, UFaction*>& Elem : Factions)
	{
		if (Elem.Value->GetName() == Name) return Elem.Value;
	}
	return nullptr;
}

int UFactionSubsystem::GetNumberOfFactions()
{
	return Factions.Num();
}

void UFactionSubsystem::ClearFactions()
{
	Factions.Empty();
}