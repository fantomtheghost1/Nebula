// Fill out your copyright notice in the Description page of Project Settings.


#include "Salvage.h"

// Sets default values
ASalvage::ASalvage()
{
 	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;

	RootComponent = CreateDefaultSubobject<USceneComponent>(TEXT("Root"));
	
	MeshComponent = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("Mesh"));
	MeshComponent->SetupAttachment(RootComponent);
	
	MeshComponent->SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);
	MeshComponent->SetCollisionResponseToChannel(ECC_Visibility, ECollisionResponse::ECR_Block);
	
	Resources = CreateDefaultSubobject<UCargoComponent>(TEXT("Resources"));
	
	DockingComponent = CreateDefaultSubobject<UDockingComponent>(TEXT("Docking"));
	
	SalvageComponent = CreateDefaultSubobject<USalvageComponent>(TEXT("Salvage"));
}
