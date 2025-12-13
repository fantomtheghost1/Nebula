// Fill out your copyright notice in the Description page of Project Settings.


#include "NebulaPlayerController.h"
#include "EnhancedInputSubsystems.h"
#include "EnhancedInputComponent.h"
#include "Ship.h"
#include "Kismet/KismetSystemLibrary.h"

void ANebulaPlayerController::BeginPlay()
{
	Super::BeginPlay();
	
	Ship = Cast<AShip>(GetPawn());
	Camera = Ship->FindComponentByClass<UCameraComponent>();
	SpringArm = Ship->FindComponentByClass<USpringArmComponent>();
	
	UpdateCameraRotation();
	
	if (UEnhancedInputLocalPlayerSubsystem* Subsystem =
		ULocalPlayer::GetSubsystem<UEnhancedInputLocalPlayerSubsystem>(GetLocalPlayer()))
	{
		Subsystem->AddMappingContext(DefaultMappingContext, 0);
	}
	
	if (UEnhancedInputComponent* EI = Cast<UEnhancedInputComponent>(InputComponent))
	{
		EI->BindAction(QuitAction, ETriggerEvent::Started, this, &ANebulaPlayerController::Quit);
		EI->BindAction(ZoomAction, ETriggerEvent::Started, this, &ANebulaPlayerController::UpdateZoom);
		EI->BindAction(InteractAction, ETriggerEvent::Started, this, &ANebulaPlayerController::Interact);
		EI->BindAction(AltAction, ETriggerEvent::Triggered, this, &ANebulaPlayerController::Interact);
	}
	
	bShowMouseCursor = true;
	bEnableClickEvents = true;
	bEnableMouseOverEvents = true;
}

void ANebulaPlayerController::UpdateCameraRotation()
{
	FVector ToTarget = Ship->GetActorLocation() - Camera->GetComponentLocation();
	FRotator CameraRot = Camera->GetComponentRotation();
	
	CameraRot.Pitch = ToTarget.Rotation().Pitch;
	Camera->SetWorldRotation(CameraRot);
}

void ANebulaPlayerController::Quit()
{
	UKismetSystemLibrary::QuitGame(
		this,                   
		this,                   
		EQuitPreference::Quit,  
		false                   
	);
}

void ANebulaPlayerController::UpdateZoom(const FInputActionValue& ZoomNormalized)
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

void ANebulaPlayerController::Interact()
{
	FHitResult HitResult;
	GetHitResultUnderCursor(ECC_Visibility, false, HitResult);
	
	if (HitResult.IsValidBlockingHit())
	{
		FVector NewLocation = FVector(HitResult.ImpactPoint.X, HitResult.ImpactPoint.Y, 0.0f);
		Ship->SetNextWaypoint(NewLocation);
	}
}
	