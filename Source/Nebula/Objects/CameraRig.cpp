// Fill out your copyright notice in the Description page of Project Settings.


#include "CameraRig.h"

#include "Nebula/NebulaPlayerController.h"

// Sets default values
ACameraRig::ACameraRig()
{
 	// Set this pawn to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;
	PrimaryActorTick.bTickEvenWhenPaused = true;
	
	RootComponent = CreateDefaultSubobject<USceneComponent>(TEXT("Root"));
	
	SpringArmComponent = CreateDefaultSubobject<USpringArmComponent>(TEXT("SpringArm"));
	SpringArmComponent->SetupAttachment(RootComponent);
	
	CameraComponent = CreateDefaultSubobject<UCameraComponent>(TEXT("Camera"));
	CameraComponent->SetupAttachment(SpringArmComponent);

}

// Called when the game starts or when spawned
void ACameraRig::BeginPlay()
{
	Super::BeginPlay();
	
	ANebulaPlayerController* PC = Cast<ANebulaPlayerController>(GetWorld()->GetFirstPlayerController());
	PC->RegisterCamera(this);
	
	if (!Target) return;
	SetActorLocation(Target->GetActorLocation(), false);
}

// Called every frame
void ACameraRig::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);
	
	if (FollowTarget && Target)
	{
		SetActorLocation(Target->GetActorLocation(), false);
	}

}

