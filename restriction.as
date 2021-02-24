#include "include"
#include "point_checkpoint"
#include "controller"
#include "NewEntityData"
#include "CExpCrab"

array<ItemMapping@> g_ItemMappings = { 
    ItemMapping( "weapon_9mmAR", "weapon_ak74" ),
    ItemMapping( "weapon_mp5", "weapon_ak74" ),
    ItemMapping( "weapon_9mmhandgun", "weapon_aps" ),
    ItemMapping( "weapon_357", "weapon_paranoia_glock" ),
    ItemMapping( "weapon_glock", "weapon_aps" ),
    ItemMapping( "weapon_eagle", "weapon_groza" ),
    ItemMapping( "weapon_m16", "weapon_aks" ),
    ItemMapping( "weapon_saw", "weapon_rpk" ),
    ItemMapping( "weapon_m249", "weapon_rpk" ),
    ItemMapping( "weapon_shotgun", "weapon_spas12" ),
    ItemMapping( "weapon_rpg", "weapon_paranoia_rpg" ),
    ItemMapping( "weapon_handgrenade", "ammo_f1"),
    ItemMapping( "weapon_crowbar", "weapon_paranoia_knife"),
    ItemMapping( "weapon_knife", "weapon_paranoia_knife"),
    ItemMapping( "weapon_uzi", "weapon_paranoia_mp5"),
    ItemMapping( "weapon_sniperrifle", "weapon_val"),

    ItemMapping( "ammo_357", "ammo_grozaammobox"),
    ItemMapping( "ammo_ARgrenades", "ammo_f1"),
    ItemMapping( "ammo_556", "ammo_rpkammobox"),
    ItemMapping( "ammo_556clip", "ammo_rpk"),
    ItemMapping( "ammo_9mmAR" ,"ammo_ak74ammobox"),
    ItemMapping( "ammo_9mm", "ammo_apsammobox"),
    ItemMapping( "ammo_9mmbox", "ammo_aksammobox"),
    ItemMapping( "ammo_9mmclip", "ammo_apsammobox"),
    ItemMapping( "ammo_buckshot", "ammo_spas12"),
    ItemMapping( "ammo_glockclip", "ammo_glockammobox"),
    ItemMapping( "ammo_mp5clip", "ammo_paranoia_mp5ammobox"),
    ItemMapping( "ammo_rpgclip", "ammo_paranoia_rpg"),
    ItemMapping( "ammo_uziclip", "ammo_val")
 };

class CMapAddItem{
    string szItemName;
    private array<Vector>@ aryPos;

    void Spawn(){
        for(uint i = 0; i < aryPos.length();i++){
            g_EntityFuncs.Create(szItemName, aryPos[i], Vector(0, Math.RandomFloat(-99, 99), 0), false);
        }
    }

    CMapAddItem(string name, array<Vector>@ pos){
        szItemName = name;
        @aryPos = pos;
    }
}

class CExtraMonster{
    private string szPath = "";
    private string szDisplayName = "";
    private array<string> aryExtraSound = {};
    private array<ItemMapping@> aryKeyValue = {};

    float iWeight = 0;

    void Precache(){
        g_Game.PrecacheModel(szPath);
        for(uint i = 0; i < aryExtraSound.length(); i++){
            g_SoundSystem.PrecacheSound(aryExtraSound[i]);
        }
    }

    void Set(CBaseMonster@ pMonster){
        if(@pMonster !is null){
            for(uint i = 0; i < aryKeyValue.length(); i++){
                if(aryKeyValue[i].get_From() == "health")
                    pMonster.pev.health = pMonster.pev.max_health = atoi(aryKeyValue[i].get_To());
            }
            pMonster.m_fCustomModel = true;
            pMonster.m_FormattedName = szDisplayName;
            g_EntityFuncs.SetModel(pMonster, this.szPath);
            g_EntityFuncs.SetSize(pMonster.pev, VEC_HUMAN_HULL_MIN, VEC_HUMAN_HULL_MAX);
        }
    }

    CExtraMonster(string _Path, string _Name, float _Weight, array<string> _Extra = {}, array<ItemMapping@> _KVPair = {}){
        this.szPath = _Path;
        this.szDisplayName = _Name;
        this.iWeight = _Weight;
        this.aryExtraSound = _Extra;
        this.aryKeyValue = _KVPair;
    }
}
const array<CExtraMonster@> aryExtraZombie = {
    CExtraMonster(
        "models/paranoia/zombie_fat.mdl",
        "Puffy mutants",
        10,
        array<string> = {"weapons/paranoia/bes/zo_alert1.wav",
                        "weapons/paranoia/bes/zo_alert2.wav",
                        "weapons/paranoia/bes/zo_attack1.wav",
                        "weapons/paranoia/bes/zo_attack2.wav",
                        "weapons/paranoia/bes/zo_pain1.wav",
                        "weapons/paranoia/bes/zo_pain2.wav"},
        array<ItemMapping@> = {ItemMapping("health", "300")}
    ),
    CExtraMonster(
        "models/paranoia/zombie_female.mdl",
        "Female mutational scientist",
        40
    ),
    CExtraMonster(
        "models/paranoia/zombie_scientist.mdl",
        "Mtational scientist",
        40
    ),
    CExtraMonster(
        "models/paranoia/zombie_soldier.mdl",
        "Mtational soldier",
        40
    ),
    CExtraMonster(
        "models/paranoia/zombie_himik.mdl",
        "NP Cleaner zombie",
        40
    ),
    CExtraMonster(
        "models/paranoia/zombie_rotten.mdl",
        "Rotten zombie",
        40
    )
};

class CExtraMonsterPosItem{
    string szClassName = "";
    array<array<int>> aryPos = {};
    CExtraMonsterPosItem(string _Name, array<array<int>> _RGB){
        this.szClassName = _Name;
        this.aryPos = _RGB;
    }

    void Spawn(){
        for(uint i = 0; i < aryPos.length(); i++){
            array<int> pos = aryPos[i];
            CBaseEntity@ pEntity = g_EntityFuncs.Create(szClassName, Vector(pos[0], pos[1], pos[2]), Vector(0, pos[3], 0), false);
            if(pEntity.pev.size.Length() <= 0)
                g_EntityFuncs.SetSize(pEntity.pev, VEC_HUMAN_HULL_MIN, VEC_HUMAN_HULL_MAX);
            CBaseMonster@ pMonster = cast<CBaseMonster@>(@pEntity);
            pMonster.m_bloodColor = BLOOD_COLOR_RED;
            if(pMonster.m_fCustomModel)
                continue;
            if(pMonster.pev.classname == "monster_zombie"){
                float flRandom = Math.RandomFloat(0, 1);
                if(flRandom <= aryExtraZombie[aryExtraZombie.length()-1].iWeight){
                    for(uint j = 0; j < aryExtraZombie.length(); j++){
                        if(flRandom <= aryExtraZombie[j].iWeight){
                            aryExtraZombie[j].Set(@pMonster);
                            break;
                        }
                    }
                }
            }
        }
    }
    
}

void MapInit(){
    
    RegisterPointCheckPointEntity();
    ControllerMapInit();

    //New weapon
    WeaponRegister();
    BatteryHookRegister();
    ExpCrab::Register();
    g_ClassicMode.SetItemMappings( @g_ItemMappings );
    g_ClassicMode.ForceItemRemap( true );

    //Recalculate weights
    float flTotal = 0;
    float flTemp = 0;
    for(uint i = 0; i < aryExtraZombie.length(); i++){
        flTotal += aryExtraZombie[i].iWeight;
    }
    for(uint i = 0; i < aryExtraZombie.length(); i++){
        aryExtraZombie[i].iWeight = aryExtraZombie[i].iWeight/flTotal + flTemp;
        flTemp = aryExtraZombie[i].iWeight;
    }
    //Precache
    for(uint i = 0; i < aryExtraZombie.length(); i++){
        aryExtraZombie[i].Precache();
    }
}

void MapActivate(){
    //Replace Weapons
    for(uint i = 0; i < g_ItemMappings.length(); i++){
        CBaseEntity@ pEntity = null;
        while( ( @pEntity = g_EntityFuncs.FindEntityByClassname( pEntity, g_ItemMappings[i].get_From() ) ) !is null ){
            CBaseEntity@ pTarget = g_EntityFuncs.CreateEntity( g_ItemMappings[i].get_To(), null, false );
            if ( pTarget is null )
                break;
            pTarget.pev.targetname = pEntity.pev.targetname;
            pTarget.pev.maxs = pEntity.pev.maxs;
            pTarget.pev.mins = pEntity.pev.mins;
            pTarget.pev.origin = pEntity.pev.origin;
            pTarget.pev.angles = pEntity.pev.angles;
            pTarget.pev.target = pEntity.pev.target;
            pTarget.pev.scale = pEntity.pev.scale;
            g_EntityFuncs.DispatchSpawn( pTarget.edict() );
            g_EntityFuncs.Remove(pEntity);
        }
    }

    //Create New Weapons
    string szMapName = string(g_Engine.mapname).ToLowercase();
    if(dicAddItem.exists(szMapName)){
        array<CMapAddItem@> aryItems = cast<array<CMapAddItem@>>(dicAddItem[szMapName]);
        for(uint i = 0; i < aryItems.length(); i++){
            aryItems[i].Spawn();
        }
    }

    //Create New Monsters
    if(dicExtraMonster.exists(szMapName)){
        array<CExtraMonsterPosItem@> aryItems = cast<array<CExtraMonsterPosItem@>>(dicExtraMonster[szMapName]);
        for(uint i = 0; i < aryItems.length(); i++){
            aryItems[i].Spawn();
        }
    }
    //Create Trigger Entity
    if(szMapName == "restriction01"){
        g_EntityFuncs.CreateEntity("game_text",  
            dictionary = {
                {"channel", "2"},
                {"fxtime", "0.25"},
                {"holdtime", "2.2"},
                {"fadeout", "0.5"},
                {"fadein", "1.5"},
                {"color2", "240 110 0"},
                {"color", "100 100 100"},
                {"effect", "1"},
                {"y", "0.67"},
                {"x", "-1"},
                {"delay", "5"},
                {"targetname", "text_credit4"},
                {"spawnflags", "1"},
                {"message", "This server enabled Enhance plugins by Dr.Abc"},
                {"origin", "2763 1162 -100"}
            }, true);
    }
}