// Fill out your copyright notice in the Description page of Project Settings.

#include "Faction.h"

UFaction::UFaction()
{
}

void UFaction::SetName(FString NewName)
{
	Name = NewName;
	Rename(*Name);
}

void UFaction::SetColor(FColor NewColor)
{
	Color = NewColor;
}

FString UFaction::GetName()
{
	return Name;
}

FColor UFaction::GetColor()
{
	return Color;
}
