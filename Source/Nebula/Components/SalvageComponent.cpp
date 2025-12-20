// Fill out your copyright notice in the Description page of Project Settings.


#include "SalvageComponent.h"

void USalvageComponent::StartSalvage()
{
	if (!DockedFleet) return;
	
	GetWorld()->GetTimerManager().SetTimer(
		SalvageTimer,
		this,
		&USalvageComponent::SalvageComplete,
		SalvageDuration, 
		true
	);
}

void USalvageComponent::SalvageComplete()
{
	if (UCargoComponent* Resources = GetOwner()->FindComponentByClass<UCargoComponent>())
	{
		DockedFleet->FindComponentByClass<UCargoComponent>()->AddCargo(Resources);
		GetOwner()->Destroy();
	}
}


