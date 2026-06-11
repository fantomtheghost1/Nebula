// Editor-only utility for asteroid generation
#pragma once

#include "CoreMinimal.h"
#include "EditorScriptableInteractiveTool.h"
#include "AsteroidGeneratorUtil.generated.h"

UCLASS()
class NEBULAEDITOR_API UAsteroidGeneratorUtil : public UEditorScriptableInteractiveTool
{
    GENERATED_BODY()

public:
    virtual void Setup() override;

    UPROPERTY(EditAnywhere, Category = "Asteroid Generator")
    TSubclassOf<AActor> AsteroidClass;
};
