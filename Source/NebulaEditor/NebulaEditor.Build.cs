using UnrealBuildTool;

public class NebulaEditor : ModuleRules
{
    public NebulaEditor(ReadOnlyTargetRules Target) : base(Target)
    {
        PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;

        PrivateDependencyModuleNames.AddRange(new string[] {
            "Core",
            "CoreUObject",
            "Engine",
            "UnrealEd",
            "EditorFramework",
            "InteractiveToolsFramework",
            "ScriptableToolsFramework",
            "EditorScriptableToolsFramework",
        });
    }
}
