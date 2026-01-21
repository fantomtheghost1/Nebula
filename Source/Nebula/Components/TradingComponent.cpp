// Fill out your copyright notice in the Description page of Project Settings.


#include "TradingComponent.h"

#include "Nebula/NebulaPlayerController.h"
#include "Nebula/Utils/NebulaLogging.h"

void UTradingComponent::Trade(UCargoItemAsset* ItemToTrade, bool IsPlayer)
{
	if (IsPlayer)
	{
		APlayerController* PC = GetWorld()->GetFirstPlayerController();
		ANebulaPlayerController* NPC = Cast<ANebulaPlayerController>(PC);
		
		if (DockedFleet)
		{
			if (DockedFleet->FindComponentByClass<UCargoComponent>())
			{
				DockedFleet->FindComponentByClass<UCargoComponent>()->SubtractCargoItem(ItemToTrade, 1);
				NPC->Credits += ItemToTrade->SalePrice;
				UE_LOG(LogGameplay, Warning, TEXT("Traded %s for %d credits."), *ItemToTrade->GetName(), ItemToTrade->SalePrice);
			} else
			{
				UE_LOG(LogGameplay, Warning, TEXT("Docked fleet does not have a cargo component."));
			}
		} else
		{
			UE_LOG(LogGameplay, Warning, TEXT("Docked fleet is null."));
		}
	}
}
