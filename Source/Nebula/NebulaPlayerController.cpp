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
	Fleet.Add(Ship);
	
	CameraTarget = Ship;
	
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
		EI->BindAction(AltAction, ETriggerEvent::Started, this, &ANebulaPlayerController::StartOrbit);
		EI->BindAction(AltAction, ETriggerEvent::Completed, this, &ANebulaPlayerController::EndOrbit);
		EI->BindAction(OrbitAction, ETriggerEvent::Triggered, this, &ANebulaPlayerController::SetOrbitAmount);
	}
	
	bShowMouseCursor = true;
	bEnableClickEvents = true;
	bEnableMouseOverEvents = true;
}

void ANebulaPlayerController::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);
	
	if (CameraTarget && SpringArm)
	{
		const FVector TargetLocation = CameraTarget->GetActorLocation();
		SpringArm->SetWorldLocation(TargetLocation);
	}
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
	if (DisableInput) return;
	float ZoomValue = ZoomNormalized.Get<float>() * ZoomSpeed;

	if (SpringArm && ZoomMax > 0.0f && ZoomMin > 0.0f)
	{
		SpringArm->TargetArmLength = FMath::Clamp(
			SpringArm->TargetArmLength + ZoomValue,
			ZoomMin,
			ZoomMax
		);
	}
}

void ANebulaPlayerController::Interact()
{
	if (DisableInput) return;
	
	FHitResult HitResult;
	GetHitResultUnderCursor(ECC_Visibility, false, HitResult);
	
	Ship->DetermineInteract(HitResult);
}

void ANebulaPlayerController::SetInputDisabled(bool InputDisabled)
{
	DisableInput = InputDisabled;
}

AShip* ANebulaPlayerController::GetShip()
{
	return Ship;
}

void ANebulaPlayerController::StartOrbit()
{
	if (DisableInput) return;
	Orbit = true;
}

void ANebulaPlayerController::EndOrbit()
{
	if (DisableInput) return;
	Orbit = false;
}

void ANebulaPlayerController::SetOrbitAmount(const FInputActionValue& MouseXY)
{
	if (DisableInput) return;
	if (!Orbit || !SpringArm || !Camera) return;
	
	FRotator OrbitRotation = SpringArm->GetRelativeRotation();
	OrbitRotation.Yaw += MouseXY.Get<FVector2D>().X * OrbitRate;
	OrbitRotation.Pitch += MouseXY.Get<FVector2D>().Y * OrbitRate;
	OrbitRotation.Pitch = FMath::Clamp(OrbitRotation.Pitch, -90.f, 90.f);

	SpringArm->SetRelativeRotation(OrbitRotation);
}
	