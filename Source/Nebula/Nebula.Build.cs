// Copyright Epic Games, Inc. All Rights Reserved.

using UnrealBuildTool;

public class Nebula : ModuleRules
{
	public Nebula(ReadOnlyTargetRules Target) : base(Target)
	{
		PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;
	
		PublicDependencyModuleNames.AddRange(new string[]
		{
			"Core", 
			"CoreUObject", 
			"Engine", 
			"InputCore", 
			"EnhancedInput",
			"UMG",
			"OnlineSubsystem",
			"OnlineSubsystemUtils",
			"AIModule",
			"NavigationSystem"
			// Tool frameworks (Editor-only; added below when building the Editor)
		});

		PrivateDependencyModuleNames.AddRange(new string[]
		{
			"OnlineSubsystemSteam", "AITestSuite", "AITestSuite", "Niagara"
		});

		// Uncomment if you are using Slate UI
		// PrivateDependencyModuleNames.AddRange(new string[] { "Slate", "SlateCore" });
		
		// Uncomment if you are using online features
		// PrivateDependencyModuleNames.Add("OnlineSubsystem");

		// To include OnlineSubsystemSteam, add it to the plugins section in your uproject file with the Enabled attribute set to true

		// Add editor-only modules only when building the Editor target
		if (Target.bBuildEditor)
		{
			PublicDependencyModuleNames.AddRange(new string[]
			{
				"InteractiveToolsFramework",
				"ScriptableToolsFramework",
				"EditorScriptableToolsFramework",
			});
		}
	}
}
