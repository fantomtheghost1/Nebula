#pragma once

#include "CoreMinimal.h"
#include "Components/ActorComponent.h"
#include "Engine/World.h"
#include "TimerManager.h"
#include "BountyTrackingComponent.generated.h"

USTRUCT(BlueprintType)
struct FBreadcrumbPoint
{
	GENERATED_BODY()

	UPROPERTY(BlueprintReadOnly)
	FVector Location;

	UPROPERTY(BlueprintReadOnly)
	float Timestamp;

	FBreadcrumbPoint()
	{
		Location = FVector::ZeroVector;
		Timestamp = 0.0f;
	}

	FBreadcrumbPoint(const FVector& InLocation, float InTimestamp)
	{
		Location = InLocation;
		Timestamp = InTimestamp;
	}
};

UCLASS(ClassGroup=(Custom), meta=(BlueprintSpawnableComponent))
class NEBULA_API UBountyTrackingComponent : public UActorComponent
{
	GENERATED_BODY()

public:
	UBountyTrackingComponent();

protected:
	virtual void BeginPlay() override;
	virtual void TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction) override;

public:
	// Sets this target as a bounty target and starts tracking
	UFUNCTION(BlueprintCallable, Category = "Bounty Tracking")
	void StartBountyTracking();

	// Stops bounty tracking and clears breadcrumbs
	UFUNCTION(BlueprintCallable, Category = "Bounty Tracking")
	void StopBountyTracking();

	// Gets the current breadcrumb trail
	UFUNCTION(BlueprintPure, Category = "Bounty Tracking")
	const TArray<FBreadcrumbPoint>& GetBreadcrumbTrail() const { return BreadcrumbTrail; }

	// Checks if this target is currently being tracked
	UFUNCTION(BlueprintPure, Category = "Bounty Tracking")
	bool IsBountyTarget() const { return bIsBountyTarget; }

	// Gets the most recent breadcrumb location
	UFUNCTION(BlueprintPure, Category = "Bounty Tracking")
	FVector GetLastKnownLocation() const;

	// Gets breadcrumbs within a specified age (in seconds)
	UFUNCTION(BlueprintPure, Category = "Bounty Tracking")
	TArray<FBreadcrumbPoint> GetRecentBreadcrumbs(float MaxAge) const;

protected:
	// Timer function to record breadcrumbs
	void RecordBreadcrumb();

	// Cleans up old breadcrumbs
	void CleanupOldBreadcrumbs();

private:
	// Whether this actor is currently a bounty target
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Bounty Tracking", meta = (AllowPrivateAccess = "true"))
	bool bIsBountyTarget;

	// How often to record breadcrumbs (in seconds)
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Bounty Tracking", meta = (AllowPrivateAccess = "true"))
	float BreadcrumbInterval;

	// How long breadcrumbs should persist (in seconds)
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Bounty Tracking", meta = (AllowPrivateAccess = "true"))
	float BreadcrumbLifetime;

	// Maximum number of breadcrumbs to keep
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Bounty Tracking", meta = (AllowPrivateAccess = "true"))
	int32 MaxBreadcrumbs;

	// The breadcrumb trail
	TArray<FBreadcrumbPoint> BreadcrumbTrail;

	// Timer handle for breadcrumb recording
	FTimerHandle BreadcrumbTimerHandle;

	// Last recorded location to avoid duplicate breadcrumbs
	FVector LastRecordedLocation;

	// Minimum distance to move before recording a new breadcrumb
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Bounty Tracking", meta = (AllowPrivateAccess = "true"))
	float MinMovementDistance;
};