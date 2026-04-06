// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Nebula/Enums/DiplomacyStates.h"
#include "UObject/Object.h"
#include "Faction.generated.h"

/**
 * 
 */
UCLASS()
class NEBULA_API UFaction : public UObject
{
	GENERATED_BODY()
	
public:
	
	UFaction();
	
	void AssignLeader(AActor* NewLeader);
	
	void RegisterMember(AActor* NewMember);
	
	void DeregisterMember(AActor* NewMember);
	
	void SetName(FName NewName);
	
	void SetColor(FColor NewColor);
	
	TArray<AActor*> GetMembers();
	
	FName GetName();
	
	FColor GetColor();
	
	void AddFactionDiplomacy(UFaction* OtherFaction, EDiplomacyStates NewState = EDiplomacyStates::NEUTRAL);
	
	void RemoveFactionDiplomacy(UFaction* OtherFaction);
	
	void SetDiplomacy(UFaction* OtherFaction, EDiplomacyStates NewState);
	
	EDiplomacyStates GetDiplomacy(UFaction* OtherFaction);
	
private:
	
	UPROPERTY(EditAnywhere, Category="Faction")
	FName Name;
	
	UPROPERTY(EditAnywhere, Category="Faction")
	FColor Color;
	
	UPROPERTY(VisibleAnywhere, Category="Faction")
	TArray<AActor*> Members;
	
	UPROPERTY(VisibleAnywhere, Category="Faction")
	AActor* Leader;
	
	UPROPERTY(VisibleAnywhere, Category="Faction")
	TMap<UFaction*, EDiplomacyStates> DiplomacyTable;
	
};
