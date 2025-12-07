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
	
	SpringArm = FindComponentByClass<USpringArmComponent>();
	Camera = FindComponentByClass<UCameraComponent>();
	
	UpdateCameraRotation();
}

void AShip::UpdateCameraRotation()
{
	FVector ToTarget = GetActorLocation() - Camera->GetComponentLocation();
	FRotator CameraRot = Camera->GetComponentRotation();
	
	CameraRot.Pitch = ToTarget.Rotation().Pitch;
	Camera->SetWorldRotation(CameraRot);
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

void AShip::SetZoom(const FInputActionValue& ZoomNormalized)
{
	float ZoomValue = ZoomNormalized.Get<float>() * ZoomSpeed;

	if (SpringArm && ZoomMax > 0.0f && ZoomMin > 0.0f)
	{
		SpringArm->TargetArmLength = FMath::Clamp(
			SpringArm->TargetArmLength + ZoomValue,
			ZoomMin,
			ZoomMax
		);
		UE_LOG(LogTemp, Warning, TEXT("Zoom Value: %f"), SpringArm->TargetArmLength);
		
	}
	UpdateCameraRotation();
}

float AShip::GetZoom()
{
	return SpringArm->TargetArmLength / ZoomMax;
}


