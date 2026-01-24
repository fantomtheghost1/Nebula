// Fill out your copyright notice in the Description page of Project Settings.


#include "Salvage.h"

// Sets default values
ASalvage::ASalvage()
{

	RootComponent = CreateDefaultSubobject<USceneComponent>(TEXT("Root"));
	
	MeshComponent = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("Mesh"));
	MeshComponent->SetupAttachment(RootComponent);
	
	MeshComponent->SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);
	MeshComponent->SetCollisionResponseToChannel(ECC_Visibility, ECollisionResponse::ECR_Block);
	
	SphereCollision = CreateDefaultSubobject<USphereComponent>(TEXT("Sphere Collision"));
	SphereCollision->SetupAttachment(RootComponent);
	
	Resources = CreateDefaultSubobject<UCargoComponent>(TEXT("Resources"));
	
	DockingComponent = CreateDefaultSubobject<UDockingComponent>(TEXT("Docking"));
	
	SalvageComponent = CreateDefaultSubobject<USalvageComponent>(TEXT("Salvage"));
}
