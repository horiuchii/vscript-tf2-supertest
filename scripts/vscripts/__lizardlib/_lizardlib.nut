//=========================================================================
//LizardLib by LizardOfOz
//Version: Beta 2
//=========================================================================

::main_script <- this;
::main_script_entity <- self;
::root_table <- getroottable();
::tf_player_manager <- Entities.FindByClassname(null, "tf_player_manager");
::tf_gamerules <- Entities.FindByClassname(null, "tf_gamerules");
tf_gamerules.ValidateScriptScope();

ClearGameEventCallbacks();

if (!("projectDir" in root_table))
    ::projectDir <- "your_project_folder/"
IncludeScript(projectDir+"/__lizardlib/constants.nut");
IncludeScript(projectDir+"/__lizardlib/listeners.nut");
IncludeScript(projectDir+"/__lizardlib/timers.nut");
IncludeScript(projectDir+"/__lizardlib/api_config.nut");
IncludeScript(projectDir+"/__lizardlib/players.nut");
IncludeScript(projectDir+"/__lizardlib/util.nut");

OnGameEvent("scorestats_accumulated_update", 99999, function()
{
    foreach(player in GetClients())
        player.TerminateScriptScope();
});