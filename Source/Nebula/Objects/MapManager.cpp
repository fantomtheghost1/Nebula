// Fill out your copyright notice in the Description page of Project Settings.


#include "MapManager.h"

#include "../NebulaGameInstance.h"

// Sets default values
AMapManager::AMapManager()
{
 	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;

}

// Called when the game starts or when spawned
void AMapManager::BeginPlay()
{
	Super::BeginPlay();
	
	UNebulaGameInstance* GameInstance = Cast<UNebulaGameInstance>(GetWorld()->GetGameInstance());
	
	FActorSpawnParameters Params;
	Params.Owner = this;
	
	for (const TPair<int, FFleetState>& Elem : GameInstance->Fleets)
	{
		if (Elem.Value.IsPlayer)
		{
			GetWorld()->SpawnActor<AFleet>(
				PlayerFleetBlueprint,
				Elem.Value.Location,
				Elem.Value.Rotation,
				Params
			);
		} else {
			GetWorld()->SpawnActor<AFleet>(
				AIFleetBlueprint,
				Elem.Value.Location,
				Elem.Value.Rotation,
				Params
			);
		}
	}
}

// Called every frame
void AMapManager::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);

}

