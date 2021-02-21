#include "include"
void PluginInit(){
	g_Module.ScriptInfo.SetAuthor("Dr.Abc");
	g_Module.ScriptInfo.SetContactInfo("Not now");
}

void MapInit(){
	WeaponRegister();

    BatteryHookRegister();
}