#include "BreadcrumbTrailComponent.h"
#include "Engine/World.h"
#include "TimerManager.h"
#include "GameFramework/Actor.h"

UBreadcrumbTrailComponent::UBreadcrumbTrailComponent()
{
	PrimaryComponentTick.bCanEverTick = false;
	
	bIsTracking = false;
	BreadcrumbInterval = 2.0f; // Record a breadcrumb every 2 seconds
	MaxBreadcrumbs = 50; // Keep up to 50 breadcrumbs
	BreadcrumbLifetime = 300.0f; // Keep breadcrumbs for 5 minutes
	MinDistanceBetweenBreadcrumbs = 500.0f; // Minimum 500 units between breadcrumbs
}

void UBreadcrumbTrailComponent::BeginPlay()
{
	Super::BeginPlay();
}

void UBreadcrumbTrailComponent::EndPlay(const EEndPlayReason::Type EndPlayReason)
{
	StopTracking();
	Super::EndPlay(EndPlayReason);
}

void UBreadcrumbTrailComponent::TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction)
{
	Super::TickComponent(DeltaTime, TickType, ThisTickFunction);
}

void UBreadcrumbTrailComponent::StartTracking()
{
	if (bIsTracking)
	{
		return;
	}

	bIsTracking = true;
	
	// Clear existing breadcrumbs when starting fresh
	ClearBreadcrumbs();
	
	// Start the timer to record breadcrumbs
	if (UWorld* World = GetWorld())
	{
		World->GetTimerManager().SetTimer(
			BreadcrumbTimerHandle,
			this,
			&UBreadcrumbTrailComponent::RecordBreadcrumb,
			BreadcrumbInterval,
			true // Loop
		);
		
		// Record the first breadcrumb immediately
		RecordBreadcrumb();
	}
}

void UBreadcrumbTrailComponent::StopTracking()
{
	if (!bIsTracking)
	{
		return;
	}

	bIsTracking = false;
	
	// Clear the timer
	if (UWorld* World = GetWorld())
	{
		World->GetTimerManager().ClearTimer(BreadcrumbTimerHandle);
	}
}

TArray<FBreadcrumb> UBreadcrumbTrailComponent::GetBreadcrumbs() const
{
	return Breadcrumbs;
}

void UBreadcrumbTrailComponent::ClearBreadcrumbs()
{
	Breadcrumbs.Empty();
}

FBreadcrumb UBreadcrumbTrailComponent::GetLatestBreadcrumb() const
{
	if (Breadcrumbs.Num() > 0)
	{
		return Breadcrumbs.Last();
	}
	
	return FBreadcrumb();
}

void UBreadcrumbTrailComponent::RecordBreadcrumb()
{
	if (!bIsTracking || !GetOwner())
	{
		return;
	}

	FVector CurrentLocation = GetOwner()->GetActorLocation();
	float CurrentTime = GetWorld()->GetTimeSeconds();
	
	// Check if we should record this breadcrumb based on distance
	if (Breadcrumbs.Num() > 0)
	{
		float DistanceFromLast = FVector::Dist(CurrentLocation, Breadcrumbs.Last().Location);
		if (DistanceFromLast < MinDistanceBetweenBreadcrumbs)
		{
			return; // Too close to the last breadcrumb
		}
	}
	
	// Add new breadcrumb
	FBreadcrumb NewBreadcrumb(CurrentLocation, CurrentTime);
	Breadcrumbs.Add(NewBreadcrumb);
	
	// Clean up old breadcrumbs
	CleanupOldBreadcrumbs();
	
	// Enforce max breadcrumb limit
	while (Breadcrumbs.Num() > MaxBreadcrumbs)
	{
		Breadcrumbs.RemoveAt(0);
	}
}

void UBreadcrumbTrailComponent::CleanupOldBreadcrumbs()
{
	if (Breadcrumbs.Num() == 0)
	{
		return;
	}
	
	float CurrentTime = GetWorld()->GetTimeSeconds();
	
	// Remove breadcrumbs that are too old
	for (int32 i = Breadcrumbs.Num() - 1; i >= 0; i--)
	{
		if (CurrentTime - Breadcrumbs[i].Timestamp > BreadcrumbLifetime)
		{
			Breadcrumbs.RemoveAt(i);
		}
		else
		{
			// Since breadcrumbs are added in chronological order,
			// we can break here as all remaining ones are newer
			break;
		}
	}
}