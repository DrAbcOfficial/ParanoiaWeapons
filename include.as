#include "CBaseParanoiaWeapon"
#include "CBaseParanoiaAmmo"
#include "weapon_ak74"
#include "weapon_aks"
#include "weapon_rpk"
#include "weapon_aps"
#include "weapon_glock"
#include "weapon_groza"
#include "weapon_val"
#include "weapon_spas12"
#include "weapon_rpg"
#include "weapon_f1"
#include "weapon_paranoia_knife"
#include "weapon_paranoia_mp5"
#include "weapon_painkiller"
#include "weapon_flashbattery"

void WeaponRegister(){

    g_Game.PrecacheGeneric( "sprites/paranoia/sniper.spr");
    g_Game.PrecacheModel( "sprites/paranoia/sniper.spr" );

    ParanoiaAmmoRegister("ammo_ak74", "ammo_ak74");
    ParanoiaAmmoRegister("ammo_ak74ammobox", "ammo_ak74ammobox");
    ParanoiaAmmoRegister("ammo_aks", "ammo_aks");
    ParanoiaAmmoRegister("ammo_aksammobox", "ammo_aksammobox");
    ParanoiaAmmoRegister("ammo_aps", "ammo_aps");
    ParanoiaAmmoRegister("ammo_apsammobox", "ammo_apsammobox");
    ParanoiaAmmoRegister("ammo_glock", "ammo_glock");
    ParanoiaAmmoRegister("ammo_glockammobox", "ammo_glockammobox");
    ParanoiaAmmoRegister("ammo_groza", "ammo_groza");
    ParanoiaAmmoRegister("ammo_grozaammobox", "ammo_grozaammobox");
    ParanoiaAmmoRegister("ammo_paranoia_mp5", "ammo_paranoia_mp5");
    ParanoiaAmmoRegister("ammo_paranoia_mp5ammobox", "ammo_paranoia_mp5ammobox");
    ParanoiaAmmoRegister("ammo_rpk", "ammo_rpk");
    ParanoiaAmmoRegister("ammo_rpkammobox", "ammo_rpkammobox");
    ParanoiaAmmoRegister("ammo_spas12", "ammo_spas12");
    ParanoiaAmmoRegister("ammo_val", "ammo_val");
    ParanoiaAmmoRegister("ammo_valammobox", "ammo_valammobox");
    ParanoiaAmmoRegister("ammo_paranoia_rpg", "ammo_paranoia_rpg");
    ParanoiaAmmoRegister("ammo_f1", "ammo_f1");
    ParanoiaAmmoRegister("ammo_droppedf1", "ammo_droppedf1");
    ParanoiaAmmoRegister("ammo_painkiller", "ammo_painkiller");
    ParanoiaAmmoRegister("ammo_flashbattery", "ammo_flashbattery");

    ParanoiaWeaponRegister("weapon_ak74", "weapon_ak74", "7Н6", "ammo_ak74");
    ParanoiaWeaponRegister("weapon_f1", "weapon_f1", "f1", "ammo_droppedf1");
    ParanoiaWeaponRegister("weapon_aks", "weapon_aks", "7Н6", "ammo_aks");
    ParanoiaWeaponRegister("weapon_rpk", "weapon_rpk", "57-Н-323С", "ammo_rpk");
    ParanoiaWeaponRegister("weapon_aps", "weapon_aps", "57-Н-181", "ammo_aps");
    ParanoiaWeaponRegister("weapon_paranoia_glock", "weapon_paranoia_glock", "9mm", "ammo_glock");
    ParanoiaWeaponRegister("weapon_groza", "weapon_groza", "7Н8", "ammo_groza");
    ParanoiaWeaponRegister("weapon_val", "weapon_val", "7Н8", "ammo_val");
    ParanoiaWeaponRegister("weapon_spas12", "weapon_spas12", "buckshot", "ammo_spas12");
    ParanoiaWeaponRegister("weapon_paranoia_knife", "weapon_paranoia_knife", "", "");
    ParanoiaWeaponRegister("weapon_painkiller", "weapon_painkiller", "painkiller", "ammo_painkiller");
    ParanoiaWeaponRegister("weapon_flashbattery", "weapon_flashbattery", "flashbattery", "ammo_painkiller");
    ParanoiaWeaponRegister("weapon_paranoia_mp5", "weapon_paranoia_mp5", "9mm", "ammo_paranoia_mp5", "ARgrenades");

    ParanoiaAmmoRegister("paranoia_rpg_rocket", "paranoia_rpg_rocket");
    ParanoiaWeaponRegister("weapon_paranoia_rpg", "weapon_paranoia_rpg", "rockets", "ammo_paranoia_rpg");
}

array<float> aryPlayerBattery(33, 100);
HookReturnCode PlayerPostThink( CBasePlayer@ pPlayer )
{
    int i  = pPlayer.entindex();
    if(pPlayer.FlashlightIsOn()){
        if(aryPlayerBattery[i] <= 0)
            pPlayer.FlashlightTurnOff();
        else
            aryPlayerBattery[i] = Math.max(0, aryPlayerBattery[i] - g_Engine.frametime);
    }
    if(pPlayer.m_iFlashBattery != int(aryPlayerBattery[i]))
        pPlayer.m_iFlashBattery = int(aryPlayerBattery[i]);
    return HOOK_CONTINUE;
}

HookReturnCode PlayerSpawn(CBasePlayer@ pPlayer){
    aryPlayerBattery[pPlayer.entindex()] = 100;
    pPlayer.GiveNamedItem("weapon_painkiller");
    pPlayer.GiveNamedItem("weapon_flashbattery");
    return HOOK_CONTINUE;
}

void BatteryHookRegister(){
    g_Hooks.RegisterHook(Hooks::Player::PlayerPostThink, @PlayerPostThink);
    g_Hooks.RegisterHook(Hooks::Player::PlayerSpawn, @PlayerSpawn);
}