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
    //Nope we don't need this enable as default
    //BatteryHookRegister();
}