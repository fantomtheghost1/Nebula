// Fill out your copyright notice in the Description page of Project Settings.

#include "Faction.h"

UFaction::UFaction()
{
}

void UFaction::RegisterMember(AActor* NewMember)
{
	Members.Add(NewMember);
}

void UFaction::DeregisterMember(AActor* NewMember)
{
	Members.Remove(NewMember);
}

void UFaction::SetName(FName NewName)
{
	Name = NewName;
}

void UFaction::SetColor(FColor NewColor)
{
	Color = NewColor;
}

TArray<AActor*> UFaction::GetMembers()
{
	return Members;
}

FName UFaction::GetName()
{
	return Name;
}

FColor UFaction::GetColor()
{
	return Color;
}

void UFaction::AddFactionDiplomacy(UFaction* OtherFaction, EDiplomacyStates NewState)
{
	if (DiplomacyTable.Contains(OtherFaction)) return;
	DiplomacyTable.Add(OtherFaction, NewState);
}

void UFaction::RemoveFactionDiplomacy(UFaction* OtherFaction)
{
	if (!DiplomacyTable.Contains(OtherFaction)) return;
	DiplomacyTable.Remove(OtherFaction);
}

void UFaction::SetDiplomacy(UFaction* OtherFaction, EDiplomacyStates NewState = EDiplomacyStates::NEUTRAL)
{
	if (!DiplomacyTable.Contains(OtherFaction)) return;
	DiplomacyTable[OtherFaction] = NewState;
}

EDiplomacyStates UFaction::GetDiplomacy(UFaction* OtherFaction)
{
	if (!DiplomacyTable.Contains(OtherFaction)) return EDiplomacyStates::UNKNOWN;
	return DiplomacyTable[OtherFaction];
}
