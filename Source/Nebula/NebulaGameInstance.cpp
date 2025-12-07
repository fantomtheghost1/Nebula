// Fill out your copyright notice in the Description page of Project Settings.


#include "NebulaGameInstance.h"
#include "OnlineSubsystem.h"
#include "Interfaces/OnlineSessionInterface.h"	


void UNebulaGameInstance::Init()
{
	Super::Init();
	
	IOnlineSubsystem* Subsystem = IOnlineSubsystem::Get();
	
	if (Subsystem)
	{
		//SessionInterface = Subsystem->GetSessionInterface();
		
		
	}
}