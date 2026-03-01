// Fill out your copyright notice in the Description page of Project Settings.


#include "ContractSubsystem.h"

FContractData* UContractSubsystem::GetContract(int ContractID)
{
	for (int i = 0; i < ActiveContracts.Num(); i++)
	{
		if (ActiveContracts[i].ContractID == ContractID)
		{
			return &ActiveContracts[i];
		}
	}
	
	return nullptr;
}

void UContractSubsystem::AddContract(FContractData NewContract)
{
	ActiveContracts.Add(NewContract);
}

void UContractSubsystem::CompleteContract(int ContractID)
{
	for (int i = 0; i < ActiveContracts.Num(); i++)
	{
		if (ActiveContracts[i].ContractID == ContractID)
		{
			ActiveContracts.RemoveAt(i);
			return;
		}
	}
}
