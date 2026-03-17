// Fill out your copyright notice in the Description page of Project Settings.


#include "ClickFloor.h"

// Sets default values
AClickFloor::AClickFloor()
{
	Tags.Add("ClickFloor");
	
	RootComponent = CreateDefaultSubobject<USceneComponent>(TEXT("Root"));
	
	MeshComponent = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("Mesh"));
	MeshComponent->SetupAttachment(RootComponent);
	
	MeshComponent->SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);
	MeshComponent->SetCollisionResponseToChannel(ECC_Visibility, ECollisionResponse::ECR_Block);
	
	static ConstructorHelpers::FObjectFinder<UStaticMesh> CubeMesh(
		TEXT("/Engine/BasicShapes/Cube.Cube")
	);
	
	if (CubeMesh.Succeeded())
	{
		MeshComponent->SetStaticMesh(CubeMesh.Object);
	}
	
	MeshComponent->SetVisibleFlag(false);
}

void AClickFloor::SetFloorSize(FVector Size)
{
	MeshComponent->SetRelativeScale3D(Size);
}

