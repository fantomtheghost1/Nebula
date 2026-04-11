// Fill out your copyright notice in the Description page of Project Settings.


#include "ContractSubsystem.h"

#include "Nebula/NebulaGameMode.h"
#include "Nebula/NebulaPlayerController.h"

FContractData* UContractSubsystem::GetContract(int Index)
{
	if (!ActiveContracts.IsValidIndex(Index)) return nullptr;
	
	return &ActiveContracts[Index];
}

void UContractSubsystem::AddContract(FContractData NewContract)
{
	ActiveContracts.Add(NewContract);
	
	if (NewContract.ContractType == EContractType::BOUNTY)
	{
		ANebulaGameMode* GM = Cast<ANebulaGameMode>(GetWorld()->GetAuthGameMode());
		if (!GM) return;
		if (GM->GetFleets().Num() == 0) return;
		NewContract.ContractTarget = GM->GetFleets()[FMath::RandRange(0, GM->GetFleets().Num() - 1)];
	}
}

void UContractSubsystem::CompleteContract(int Index)
{
	if (!ActiveContracts.IsValidIndex(Index)) return;
	
	FContractData* CompletedContract = &ActiveContracts[Index];
	if (ANebulaPlayerController* NPC = Cast<ANebulaPlayerController>(GetWorld()->GetFirstPlayerController()))
	{
		NPC->Credits += CompletedContract->CreditReward;
		UE_LOG(LogTemp, Warning, TEXT("Player has earned %d credits for completing the contract %s!"), CompletedContract->CreditReward, *CompletedContract->ContractText);
	}
	
	ActiveContracts.RemoveAt(Index);
}
