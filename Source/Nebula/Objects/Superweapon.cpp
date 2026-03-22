// Fill out your copyright notice in the Description page of Project Settings.


#include "Superweapon.h"
#include "Kismet/GameplayStatics.h"
#include "Nebula/Components/DockingComponent.h"

// Sets default values
ASuperweapon::ASuperweapon()
{
	RootComponent = CreateDefaultSubobject<USceneComponent>(TEXT("Root"));

	MeshComponent = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("Mesh"));
	MeshComponent->SetupAttachment(RootComponent);
	
	SphereComponent = CreateDefaultSubobject<USphereComponent>(TEXT("Sphere Collision"));
	SphereComponent->SetupAttachment(RootComponent);
	
	DockingComponent = CreateDefaultSubobject<UDockingComponent>(TEXT("Docking"));

}

void ASuperweapon::Fire()
{
	if (WeaponType == ESuperweapons::ISRAELCANNON)
	{
		AActor* Sun = GetClosestTarget(AActor::StaticClass(), "Sun");
		if (!Sun) return;
		
		Sun->Destroy();
		UE_LOG(LogTemp, Warning, TEXT("Sun Destroyed"));
	}
}

AActor* ASuperweapon::GetClosestTarget(TSubclassOf<AActor> TargetClass, FName Tag)
{
	if (!TargetClass) return nullptr;
	
	TArray<AActor*> FoundActors;
	UGameplayStatics::GetAllActorsOfClass(GetWorld(), TargetClass, FoundActors);
	
	AActor* ClosestActor = nullptr;
	float ClosestDistanceSq = TNumericLimits<float>::Max();
	const FVector MyLocation = GetActorLocation();

	for (AActor* Actor : FoundActors)
	{
		if (!Actor)
		{
			continue;
		}
		
		if ((Actor->Tags.Contains(Tag) and Tag != "") || Tag == "")
		{
			const float DistanceSq = FVector::DistSquared(MyLocation, Actor->GetActorLocation());
			if (DistanceSq < ClosestDistanceSq)
			{
				ClosestDistanceSq = DistanceSq;
				ClosestActor = Actor;
			}
		}
	}
	
	return ClosestActor;
}


