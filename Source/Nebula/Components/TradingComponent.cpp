// Fill out your copyright notice in the Description page of Project Settings.


#include "TradingComponent.h"

#include "Nebula/NebulaPlayerController.h"
#include "Nebula/Utils/NebulaLogging.h"

void UTradingComponent::Trade(UCargoItemAsset* ItemToTrade, bool IsPlayer, bool IsBuying)
{
	if (!ItemToTrade) return;
	
	if (IsPlayer)
	{
		APlayerController* PC = GetWorld()->GetFirstPlayerController();
		ANebulaPlayerController* NPC = Cast<ANebulaPlayerController>(PC);
		if (!DockedFleet) return;
		if (!DockedFleet->FindComponentByClass<UCargoComponent>()) return;
		
		if (!IsBuying) {
			int CargoQuantity = DockedFleet->FindComponentByClass<UCargoComponent>()->GetCargoQuantity(*ItemToTrade->GetName());
			UE_LOG(LogGameplay, Warning, TEXT("Cargo Quantity is %i"), CargoQuantity);
			if (CargoQuantity > 0)
			{
				DockedFleet->FindComponentByClass<UCargoComponent>()->SubtractCargoItem(ItemToTrade, CargoQuantity);
				NPC->Credits += (ItemToTrade->SalePrice * CargoQuantity);
				UE_LOG(LogGameplay, Warning, TEXT("Traded %s for %d credits."), *ItemToTrade->GetName(), ItemToTrade->SalePrice);
			}
		} else
		{
			int ItemQuantity = NPC->Credits / ItemToTrade->SalePrice;
			if (ItemQuantity > 0)
			{
				DockedFleet->FindComponentByClass<UCargoComponent>()->AddCargoItem(ItemToTrade, ItemQuantity);
				NPC->Credits -= (ItemToTrade->SalePrice * ItemQuantity);
			}
		}

	}
}
