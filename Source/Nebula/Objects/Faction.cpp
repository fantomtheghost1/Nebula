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
