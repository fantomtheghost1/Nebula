#include "CoreMinimal.h"
#include "GameFramework/SaveGame.h"
#include "NebulaSaveGame.generated.h"

UCLASS()
class NEBULA_API UNebulaSaveGame : public USaveGame
{
	GENERATED_BODY()
	
public:

	UPROPERTY(BlueprintReadWrite)
	FTransform PlayerTransform;

	UPROPERTY(BlueprintReadWrite)
	FTransform CameraRigTransform;
	
};
