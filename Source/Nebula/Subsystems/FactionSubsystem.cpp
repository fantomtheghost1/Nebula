// Fill out your copyright notice in the Description page of Project Settings.


#include "FactionSubsystem.h"

#include "Nebula/NebulaGameInstance.h"

UFaction* UFactionSubsystem::AddFaction(FName Name, FColor Color)
{
	UFaction* NewFaction = NewObject<UFaction>(this);
	NewFaction->SetName(Name);
	NewFaction->SetColor(Color);
	
	Factions.Add(Factions.Num() + 1, NewFaction);
	
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