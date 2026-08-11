#include "BountyTrackingComponent.h"
#include "Engine/World.h"
#include "GameFramework/Actor.h"

UBountyTrackingComponent::UBountyTrackingComponent()
{
	PrimaryComponentTick.bCanEverTick = true;
	PrimaryComponentTick.TickInterval = 1.0f; // Tick every second for cleanup

	bIsBountyTarget = false;
	BreadcrumbInterval = 2.0f; // Record breadcrumb every 2 seconds
	BreadcrumbLifetime = 300.0f; // Keep breadcrumbs for 5 minutes
	MaxBreadcrumbs = 150; // Max 150 breadcrumbs (5 minutes worth)
	MinMovementDistance = 100.0f; // 1 meter minimum movement
	LastRecordedLocation = FVector::ZeroVector;
}

void UBountyTrackingComponent::BeginPlay()
{
	Super::BeginPlay();
	
	LastRecordedLocation = GetOwner()->GetActorLocation();
}

void UBountyTrackingComponent::TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction)
{
	Super::TickComponent(DeltaTime, TickType, ThisTickFunction);

	if (bIsBountyTarget)
	{
		CleanupOldBreadcrumbs();
	}
}

void UBountyTrackingComponent::StartBountyTracking()
{
	if (bIsBountyTarget)
	{
		return; // Already tracking
	}

	bIsBountyTarget = true;
	BreadcrumbTrail.Empty();
	LastRecordedLocation = GetOwner()->GetActorLocation();

	// Start the breadcrumb recording timer
	if (UWorld* World = GetWorld())
	{
		World->GetTimerManager().SetTimer(
			BreadcrumbTimerHandle,
			this,
			&UBountyTrackingComponent::RecordBreadcrumb,
			BreadcrumbInterval,
			true // Loop
		);
	}

	// Record initial breadcrumb
	RecordBreadcrumb();
}

void UBountyTrackingComponent::StopBountyTracking()
{
	if (!bIsBountyTarget)
	{
		return; // Not currently tracking
	}

	bIsBountyTarget = false;

	// Clear the timer
	if (UWorld* World = GetWorld())
	{
		World->GetTimerManager().ClearTimer(BreadcrumbTimerHandle);
	}

	// Clear breadcrumbs
	BreadcrumbTrail.Empty();
}

FVector UBountyTrackingComponent::GetLastKnownLocation() const
{
	if (BreadcrumbTrail.Num() > 0)
	{
		return BreadcrumbTrail.Last().Location;
	}
	return GetOwner() ? GetOwner()->GetActorLocation() : FVector::ZeroVector;
}

TArray<FBreadcrumbPoint> UBountyTrackingComponent::GetRecentBreadcrumbs(float MaxAge) const
{
	TArray<FBreadcrumbPoint> RecentBreadcrumbs;
	
	if (UWorld* World = GetWorld())
	{
		float CurrentTime = World->GetTimeSeconds();
		
		for (const FBreadcrumbPoint& Breadcrumb : BreadcrumbTrail)
		{
			if (CurrentTime - Breadcrumb.Timestamp <= MaxAge)
			{
				RecentBreadcrumbs.Add(Breadcrumb);
			}
		}
	}
	
	return RecentBreadcrumbs;
}

void UBountyTrackingComponent::RecordBreadcrumb()
{
	if (!bIsBountyTarget || !GetOwner())
	{
		return;
	}

	FVector CurrentLocation = GetOwner()->GetActorLocation();
	
	// Check if we've moved enough to warrant a new breadcrumb
	float DistanceMoved = FVector::Dist(CurrentLocation, LastRecordedLocation);
	if (DistanceMoved < MinMovementDistance && BreadcrumbTrail.Num() > 0)
	{
		return;
	}

	if (UWorld* World = GetWorld())
	{
		float CurrentTime = World->GetTimeSeconds();
		FBreadcrumbPoint NewBreadcrumb(CurrentLocation, CurrentTime);
		
		BreadcrumbTrail.Add(NewBreadcrumb);
		LastRecordedLocation = CurrentLocation;
		
		// Ensure we don't exceed max breadcrumbs
		if (BreadcrumbTrail.Num() > MaxBreadcrumbs)
		{
			BreadcrumbTrail.RemoveAt(0);
		}
	}
}

void UBountyTrackingComponent::CleanupOldBreadcrumbs()
{
	if (!bIsBountyTarget || BreadcrumbTrail.Num() == 0)
	{
		return;
	}

	if (UWorld* World = GetWorld())
	{
		float CurrentTime = World->GetTimeSeconds();
		
		// Remove breadcrumbs that are too old
		for (int32 i = BreadcrumbTrail.Num() - 1; i >= 0; i--)
		{
			if (CurrentTime - BreadcrumbTrail[i].Timestamp > BreadcrumbLifetime)
			{
				BreadcrumbTrail.RemoveAt(i);
			}
			else
			{
				// Since breadcrumbs are added chronologically, we can break here
				break;
			}
		}
	}
}