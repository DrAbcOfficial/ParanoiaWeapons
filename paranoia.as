#include "include"
void PluginInit(){
    g_Module.ScriptInfo.SetAuthor("Dr.Abc");
    g_Module.ScriptInfo.SetContactInfo("""
        ========================================
        |                                      |
        |      |----------------------\        |
        |      |                      |        |
        |      |                      |        |
        |      |                      |        |
        |      |                      /        |
        |      |----------------------         |
        |      |                               |
        |      |                               |
        |      |                               |
        |      |                               |
        |                                      |
        ========================================
    """);
}

void MapInit(){
    WeaponRegister();
    BatteryHookRegister();
}