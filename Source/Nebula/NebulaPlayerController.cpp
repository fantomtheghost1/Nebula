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
	
	if (UEnhancedInputLocalPlayerSubsystem* Subsystem =
		ULocalPlayer::GetSubsystem<UEnhancedInputLocalPlayerSubsystem>(GetLocalPlayer()))
	{
		Subsystem->AddMappingContext(DefaultMappingContext, 0);
	}
	
	if (UEnhancedInputComponent* EI = Cast<UEnhancedInputComponent>(InputComponent))
	{
		EI->BindAction(QuitAction, ETriggerEvent::Started, this, &ANebulaPlayerController::Quit);
		EI->BindAction(ZoomAction, ETriggerEvent::Started, this, &ANebulaPlayerController::UpdateZoom);
		EI->BindAction(QuitAction, ETriggerEvent::Started, this, &ANebulaPlayerController::Quit);
	}
	
	bShowMouseCursor = true;
	bEnableClickEvents = true;
	bEnableMouseOverEvents = true;
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
	Ship->SetZoom(ZoomNormalized);
}

void ANebulaPlayerController::Interact()
{
}
