// Fill out your copyright notice in the Description page of Project Settings.


#include "SkillSubsystem.h"

#include "Nebula/NebulaPlayerController.h"

void USkillSubsystem::AddSpeedFactor(float NewSpeedFactor)
{
	SpeedFactor += NewSpeedFactor;
	
	ANebulaPlayerController* PlayerController = Cast<ANebulaPlayerController>(GetWorld()->GetFirstPlayerController());
	UMoverComponent* MoverComponent = PlayerController->GetFleet()->FindComponentByClass<UMoverComponent>();
	
	float FlySpeed;
	MoverComponent->GetFlySpeed(FlySpeed);
	
	float NewFlySpeed = FlySpeed * SpeedFactor;
	MoverComponent->SetFlySpeed(NewFlySpeed);
	
	UE_LOG(LogTemp, Warning, TEXT("Speed Factor: %f"), SpeedFactor);
	UE_LOG(LogTemp, Warning, TEXT("Fly Speed: %f"), NewFlySpeed);
}

float USkillSubsystem::GetSpeedFactor()
{
	return SpeedFactor;
}

void USkillSubsystem::AddSkillPoint()
{
	SkillPoints += 1;
}

void USkillSubsystem::SubtractSkillPoint()
{
	SkillPoints -= 1;
}

int USkillSubsystem::GetSkillPoints()
{
	return SkillPoints;
}
