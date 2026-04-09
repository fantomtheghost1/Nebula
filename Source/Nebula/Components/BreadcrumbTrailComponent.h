#pragma once

#include "CoreMinimal.h"
#include "Components/ActorComponent.h"
#include "Engine/World.h"
#include "TimerManager.h"
#include "BreadcrumbTrailComponent.generated.h"

USTRUCT(BlueprintType)
struct FBreadcrumb
{
	GENERATED_BODY()

	UPROPERTY(BlueprintReadOnly)
	FVector Location;

	UPROPERTY(BlueprintReadOnly)
	Float Timestamp;

	FBreadcrumb()
	{
		Location = FVector::ZeroVector;
		Timestamp = 0.0f;
	}

	FBreadcrumb(FVector InLocation, float InTimestamp)
	{
		Location = InLocation;
		Timestamp = InTimestamp;
	}
};

UCLASS(ClassGroup=(Custom), meta=(BlueprintSpawnableComponent))
class NEBULA_API UBreadcrumbTrailComponent : public UActorComponent
{
	GENERATED_BODY()

public:
	UBreadcrumbTrailComponent();

protected:
	virtual void BeginPlay() override;
	virtual void EndPlay(const EEndPlayReason::Type EndPlayReason) override;

public:
	virtual void TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction) override;

	// Start tracking breadcrumbs for this target
	UFUNCTION(BlueprintCallable, Category = "Breadcrumb Trail")
	void StartTracking();

	// Stop tracking breadcrumbs
	UFUNCTION(BlueprintCallable, Category = "Breadcrumb Trail")
	void StopTracking();

	// Get all current breadcrumbs
	UFUNCTION(BlueprintCallable, Category = "Breadcrumb Trail")
	TArray<FBreadcrumb> GetBreadcrumbs() const;

	// Clear all breadcrumbs
	UFUNCTION(BlueprintCallable, Category = "Breadcrumb Trail")
	void ClearBreadcrumbs();

	// Get the latest breadcrumb
	UFUNCTION(BlueprintCallable, Category = "Breadcrumb Trail")
	FBreadcrumb GetLatestBreadcrumb() const;

protected:
	// Timer callback to record breadcrumbs
	void RecordBreadcrumb();

	// Clean up old breadcrumbs
	void CleanupOldBreadcrumbs();

private:
	// Array of breadcrumbs
	UPROPERTY()
	TArray<FBreadcrumb> Breadcrumbs;

	// Timer handle for recording breadcrumbs
	FTimerHandle BreadcrumbTimerHandle;

	// Whether we're currently tracking
	UPROPERTY()
	bool bIsTracking;

	// Interval between breadcrumb recordings (in seconds)
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Breadcrumb Trail", meta = (AllowPrivateAccess = "true"))
	float BreadcrumbInterval;

	// Maximum number of breadcrumbs to keep
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Breadcrumb Trail", meta = (AllowPrivateAccess = "true"))
	int32 MaxBreadcrumbs;

	// Maximum age of breadcrumbs (in seconds)
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Breadcrumb Trail", meta = (AllowPrivateAccess = "true"))
	float BreadcrumbLifetime;

	// Minimum distance between breadcrumbs
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Breadcrumb Trail", meta = (AllowPrivateAccess = "true"))
	float MinDistanceBetweenBreadcrumbs;
};