// Fill out your copyright notice in the Description page of Project Settings.


#include "Ship.h"

#include "Blueprint/UserWidget.h"
#include "Misc/OutputDeviceNull.h"


// Sets default values
AShip::AShip()
{
 	// Set this pawn to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;
}

// Called when the game starts or when spawned
void AShip::BeginPlay()
{
	Super::BeginPlay();
}

// Called every frame
void AShip::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);

}

// Called to bind functionality to input
void AShip::SetupPlayerInputComponent(UInputComponent* PlayerInputComponent)
{
	Super::SetupPlayerInputComponent(PlayerInputComponent);

}

void AShip::SetFlySpeed(float NewSpeed)
{
	FlySpeed = NewSpeed;
}

void AShip::GetFlySpeed(float& OutSpeed)
{
	OutSpeed = FlySpeed;
}


