// Fill out your copyright notice in the Description page of Project Settings.


#include "NebulaPlayerController.h"

#include "EnhancedInputSubsystems.h"
#include "EnhancedInputComponent.h"
#include "NebulaGameMode.h"
#include "EngineUtils.h"
#include "Blueprint/UserWidget.h"
#include "GameFramework/GameUserSettings.h"
#include "NebulaGameInstance.h"
#include "Kismet/GameplayStatics.h"
#include "Utils/NebulaLogging.h"

void ANebulaPlayerController::BeginPlay()
{
	Super::BeginPlay();
	
	UGameUserSettings* Settings = GEngine->GetGameUserSettings();
	Settings->SetOverallScalabilityLevel(0);
	Settings->ApplySettings(true);
	
	Fleet = Cast<AFleet>(GetPawn());
	Ship = Cast<AShip>(GetPawn());
	
	if (UEnhancedInputLocalPlayerSubsystem* Subsystem =
		ULocalPlayer::GetSubsystem<UEnhancedInputLocalPlayerSubsystem>(GetLocalPlayer()))
	{
		Subsystem->AddMappingContext(DefaultMappingContext, 0);
	}
	
	if (UEnhancedInputComponent* EI = Cast<UEnhancedInputComponent>(InputComponent))
	{
		EI->BindAction(QuitAction, ETriggerEvent::Started, this, &ANebulaPlayerController::TogglePaused);
		EI->BindAction(ZoomAction, ETriggerEvent::Started, this, &ANebulaPlayerController::UpdateZoom);
		EI->BindAction(InteractAction, ETriggerEvent::Started, this, &ANebulaPlayerController::Interact);
		EI->BindAction(AltAction, ETriggerEvent::Started, this, &ANebulaPlayerController::StartOrbit);
		EI->BindAction(AltAction, ETriggerEvent::Completed, this, &ANebulaPlayerController::EndOrbit);
		EI->BindAction(OrbitAction, ETriggerEvent::Triggered, this, &ANebulaPlayerController::SetOrbitAmount);
		EI->BindAction(InventoryAction, ETriggerEvent::Started, this, &ANebulaPlayerController::ToggleInventory);
		EI->BindAction(TabAction, ETriggerEvent::Started, this, &ANebulaPlayerController::ToggleFleetComp);
		EI->BindAction(ConstructionAction, ETriggerEvent::Started, this, &ANebulaPlayerController::Construct);
	}
	
	bShowMouseCursor = true;
	bEnableClickEvents = true;
	bEnableMouseOverEvents = true;
}

void ANebulaPlayerController::TogglePaused()
{
	UWorld* World = GetWorld();
	if (!World)
	{
		return;
	}
	
	UGameplayStatics::SetGamePaused(World, true);
	
	if (!PauseWidget)
	{
		PauseWidget = CreateWidget<UUserWidget>(GetWorld(), PauseWidgetClass);	
	}
	PauseWidget->AddToViewport();
}

void ANebulaPlayerController::UpdateZoom(const FInputActionValue& ZoomNormalized)
{
	if (DisableInput) return;
	float ZoomValue = ZoomNormalized.Get<float>() * ZoomSpeed;

	if (SpringArm && ZoomMax > 0.0f && ZoomMin > 0.0f)
	{
		UE_LOG(LogBackend, Warning, TEXT("Zooming"));
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
	
	if (Fleet)
	{
		Fleet->DetermineInteract(HitResult);
	} else if (Ship)
	{
		Ship->DetermineInteract(HitResult);
	}
}

void ANebulaPlayerController::Construct()
{
	if (DisableInput) return;
	
	FHitResult HitResult;
	GetHitResultUnderCursor(ECC_Visibility, false, HitResult);
	
	if (HitResult.IsValidBlockingHit())
	{
		if (HitResult.GetActor()->ActorHasTag("ClickFloor"))
		{
			FVector ConstructionSpawnLocation = FVector(HitResult.ImpactPoint.X, HitResult.ImpactPoint.Y, 10.0f);
			if (ConstructionClass)
			{
				FActorSpawnParameters SpawnParams;
				SpawnParams.Owner = this;
				SpawnParams.Instigator = GetInstigator();
				
				FRotator Rotation = FRotator::ZeroRotator;
				
				AActor* Spawned = GetWorld()->SpawnActor<AActor>(ConstructionClass, ConstructionSpawnLocation, Rotation, SpawnParams);
			}
		}
	}
}

void ANebulaPlayerController::SetInputDisabled(bool InputDisabled)
{
	DisableInput = InputDisabled;
}

AFleet* ANebulaPlayerController::GetFleet()
{
	return Fleet;
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

void ANebulaPlayerController::ToggleInventory()
{
	if (!InventoryWidget)
	{
		InventoryWidget = CreateWidget<UUserWidget>(GetWorld(), InventoryWidgetClass);	
	}
	
	if (InventoryWidget && !Inventory)
	{
		InventoryWidget->AddToViewport();
		Inventory = true;
	} else if (InventoryWidget && Inventory) {
		UE_LOG(LogBackend, Warning, TEXT("Hiding inventory"));
		InventoryWidget->RemoveFromParent();
		Inventory = false;
	}
}

void ANebulaPlayerController::ToggleFleetComp()
{
	if (!GameWidget)
	{
		GameWidget = CreateWidget<UUserWidget>(GetWorld(), GameWidgetClass);	
	}
	
	if (GameWidget && !FleetComp)
	{
		GameWidget->AddToViewport();
		FleetComp = true;
	} else if (GameWidget && FleetComp) {
		GameWidget->RemoveFromParent();
		GameWidget = nullptr;
		FleetComp = false;
	}
}

bool ANebulaPlayerController::GetInputDisabled()
{
	return DisableInput;
}

void ANebulaPlayerController::SetOrbitAmount(const FInputActionValue& MouseXY)
{
	if (DisableInput) return;
	if (!Orbit || !SpringArm || !CameraRig) return;
	
	FRotator OrbitRotation = CameraRig->GetActorRotation();
	UE_LOG(LogBackend, Warning, TEXT("Orbiting Yaw: %f"), OrbitRotation.Yaw);
	UE_LOG(LogBackend, Warning, TEXT("Orbiting Pitch: %f"), OrbitRotation.Pitch);
	OrbitRotation.Yaw += MouseXY.Get<FVector2D>().X * OrbitRate;
	OrbitRotation.Pitch += MouseXY.Get<FVector2D>().Y * OrbitRate;
	OrbitRotation.Pitch = FMath::Clamp(OrbitRotation.Pitch, -90.f, 90.f);
	
	CameraRig->SetActorRotation(OrbitRotation);
}

void ANebulaPlayerController::RegisterCamera(ACameraRig* NewCameraRig)
{
	CameraRig = NewCameraRig;
	SetViewTargetWithBlend(CameraRig, 0.0f);
	SpringArm = CameraRig->FindComponentByClass<USpringArmComponent>();
	SpringArm->TargetArmLength = ZoomMin;
	UE_LOG(LogBackend, Warning, TEXT("SpringArm: %s"), *GetNameSafe(SpringArm));
}
	