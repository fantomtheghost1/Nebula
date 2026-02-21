// Fill out your copyright notice in the Description page of Project Settings.


#include "LeaderSubsystem.h"

FLeader ULeaderSubsystem::GenerateLeader()
{
	TArray<FName> LeaderNames = {
		FName(TEXT("Kael Vantros")),
		FName(TEXT("Nyra Solenne")),
		FName(TEXT("Orin Calyx")),
		FName(TEXT("Zara Quell")),
		FName(TEXT("Tovan Rhyse")),
		FName(TEXT("Lira Vexley")),
		FName(TEXT("Soren Halcyon")),
		FName(TEXT("Mira Kestrel")),
		FName(TEXT("Dax Arclight")),
		FName(TEXT("Eris Novayne")),
		FName(TEXT("Juno Starling")),
		FName(TEXT("Riven Thorne")),
		FName(TEXT("Vela Sable")),
		FName(TEXT("Cyrus Drift")),
		FName(TEXT("Selene Vox")),
		FName(TEXT("Kira Ionis")),
		FName(TEXT("Rowan Skysteel")),
		FName(TEXT("Astra Veyron")),
		FName(TEXT("Nolan Zephyr")),
		FName(TEXT("Iris Helix"))
	};
	
	const int32 RandomIndex = FMath::RandRange(0, LeaderNames.Num() - 1);
	FLeader NewLeader = FLeader(LeaderNames[RandomIndex]);
	return NewLeader;
}

