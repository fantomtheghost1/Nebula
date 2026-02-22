#pragma once

#include "CoreMinimal.h"
#include "Components/PrimitiveComponent.h"
#include "SpawnRingsComponent.generated.h"

UCLASS(ClassGroup=(Debug), meta=(BlueprintSpawnableComponent))
class NEBULA_API USpawnRingsComponent : public UPrimitiveComponent
{
	GENERATED_BODY()

public:
	USpawnRingsComponent();

	// Radii to visualize (typically set by the owning actor)
	UPROPERTY(EditAnywhere, Category="Spawn Rings", meta=(ClampMin="0.0"))
	float RadiusMin = 200.0f;

	UPROPERTY(EditAnywhere, Category="Spawn Rings", meta=(ClampMin="0.0"))
	float RadiusMax = 600.0f;

	UPROPERTY(EditAnywhere, Category="Spawn Rings")
	FColor RadiusMinColor = FColor::Green;

	UPROPERTY(EditAnywhere, Category="Spawn Rings")
	FColor RadiusMaxColor = FColor::Cyan;

	UPROPERTY(EditAnywhere, Category="Spawn Rings", meta=(ClampMin="8", ClampMax="256"))
	int32 Segments = 64;

	UPROPERTY(EditAnywhere, Category="Spawn Rings", meta=(ClampMin="0.1"))
	float Thickness = 2.0f;

	UPROPERTY(EditAnywhere, Category="Spawn Rings")
	bool bEnabled = true;

	// If true, circles are drawn in the component's local XY plane (rotates with actor/component).
	// If false, circles are drawn in world XY plane.
	UPROPERTY(EditAnywhere, Category="Spawn Rings")
	bool bUseLocalAxes = true;

	// Optional offset from the component location (local space)
	UPROPERTY(EditAnywhere, Category="Spawn Rings")
	FVector LocalCenterOffset = FVector::ZeroVector;
	
	// UPrimitiveComponent
	virtual FPrimitiveSceneProxy* CreateSceneProxy() override;
	virtual FBoxSphereBounds CalcBounds(const FTransform& LocalToWorld) const override;
};