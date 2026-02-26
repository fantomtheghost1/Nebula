#include "SpawnRingsComponent.h"

#include "PrimitiveSceneProxy.h"
#include "SceneManagement.h" // DrawCircle
#include "Engine/Engine.h"

namespace SpawnRings
{
	class FSpawnRingsSceneProxy final : public FPrimitiveSceneProxy
	{
	public:
		explicit FSpawnRingsSceneProxy(const USpawnRingsComponent* InComponent)
			: FPrimitiveSceneProxy(InComponent)
			, bEnabled(InComponent->bEnabled)
			, RadiusMin(InComponent->RadiusMin)
			, RadiusMax(InComponent->RadiusMax)
			, RadiusMinColor(InComponent->RadiusMinColor)
			, RadiusMaxColor(InComponent->RadiusMaxColor)
			, Segments(FMath::Clamp(InComponent->Segments, 8, 256))
			, Thickness(FMath::Max(0.1f, InComponent->Thickness))
			, bUseLocalAxes(InComponent->bUseLocalAxes)
			, LocalCenterOffset(InComponent->LocalCenterOffset)
		{
		}

		// Required in newer UE versions (otherwise proxy is abstract)
		virtual SIZE_T GetTypeHash() const override
		{
			static int32 UniqueTypeId;
			return reinterpret_cast<SIZE_T>(&UniqueTypeId);
		}

		virtual void GetDynamicMeshElements(
			const TArray<const FSceneView*>& Views,
			const FSceneViewFamily& ViewFamily,
			uint32 VisibilityMap,
			FMeshElementCollector& Collector) const override
		{
#if WITH_EDITOR
			if (!bEnabled)
			{
				return;
			}

			// Only draw in editor view families
			if (!ViewFamily.EngineShowFlags.Editor)
			{
				return;
			}

			// In FPrimitiveSceneProxy, GetLocalToWorld() is a matrix (not an FTransform)
			const FMatrix& L2W = GetLocalToWorld();

			const FVector Center =
				L2W.TransformPosition(LocalCenterOffset);

			// Choose axes (local or world)
			const FVector XAxis = bUseLocalAxes ? L2W.GetUnitAxis(EAxis::X) : FVector(1, 0, 0);
			const FVector YAxis = bUseLocalAxes ? L2W.GetUnitAxis(EAxis::Y) : FVector(0, 1, 0);

			const float RMin = FMath::Max(0.0f, RadiusMin);
			const float RMax = FMath::Max(0.0f, RadiusMax);

			for (int32 ViewIndex = 0; ViewIndex < Views.Num(); ++ViewIndex)
			{
				if ((VisibilityMap & (1u << ViewIndex)) == 0)
				{
					continue;
				}

				FPrimitiveDrawInterface* PDI = Collector.GetPDI(ViewIndex);

				// World-space overlay depth group
				const uint8 DepthPriority = SDPG_World;

				DrawCircle(PDI, Center, XAxis, YAxis, RadiusMinColor, RMin, Segments, DepthPriority, Thickness);
				DrawCircle(PDI, Center, XAxis, YAxis, RadiusMaxColor, RMax, Segments, DepthPriority, Thickness);
			}
#endif
		}

		virtual FPrimitiveViewRelevance GetViewRelevance(const FSceneView* View) const override
		{
			FPrimitiveViewRelevance Relevance;

#if WITH_EDITOR
			const bool bEditorView = View && View->Family && View->Family->EngineShowFlags.Editor;

			Relevance.bDrawRelevance = bEnabled && bEditorView;
			Relevance.bDynamicRelevance = true;

			// This helps it behave like an editor overlay primitive
			Relevance.bEditorPrimitiveRelevance = true;

			// We’re drawing lines/circles via PDI; translucency flags are not critical,
			// but leaving this on generally avoids odd “not drawn” cases in some setups.
			Relevance.bNormalTranslucency = true;
#endif

			return Relevance;
		}

		virtual uint32 GetMemoryFootprint() const override
		{
			return sizeof(*this) + GetAllocatedSize();
		}

	private:
		const bool bEnabled;
		const float RadiusMin;
		const float RadiusMax;
		const FColor RadiusMinColor;
		const FColor RadiusMaxColor;
		const int32 Segments;
		const float Thickness;
		const bool bUseLocalAxes;
		const FVector LocalCenterOffset;
	};
}

USpawnRingsComponent::USpawnRingsComponent()
{
	PrimaryComponentTick.bCanEverTick = false;

	bHiddenInGame = true;
	SetCollisionEnabled(ECollisionEnabled::NoCollision);

	// Treat as editor visualization aid
	//SetIsVisualizationComponent(true);

	// Usually you don't want to click this in editor
	bSelectable = false;

	// Ensure it can render even if nothing else changes
	SetMobility(EComponentMobility::Movable);
}

FPrimitiveSceneProxy* USpawnRingsComponent::CreateSceneProxy()
{
#if WITH_EDITOR
	return bEnabled ? new SpawnRings::FSpawnRingsSceneProxy(this) : nullptr;
#else
	return nullptr;
#endif
}

FBoxSphereBounds USpawnRingsComponent::CalcBounds(const FTransform& LocalToWorld) const
{
	const float R = FMath::Max3(0.0f, RadiusMin, RadiusMax);

	// Include center offset so bounds stay correct
	const FVector Center = LocalToWorld.TransformPosition(LocalCenterOffset);

	const FVector Extent(R, R, 10.0f);
	const FBox Box(Center - Extent, Center + Extent);

	return FBoxSphereBounds(Box);
}