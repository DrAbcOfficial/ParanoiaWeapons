#include "include"
#include "../point_checkpoint"
#include "controller"

array<ItemMapping@> g_ItemMappings = { 
    ItemMapping( "weapon_9mmAR", "weapon_ak74" ),
    ItemMapping( "weapon_mp5", "weapon_ak74" ),
    ItemMapping( "weapon_9mmhandgun", "weapon_aps" ),
    ItemMapping( "weapon_357", "weapon_paranoia_glock" ),
    ItemMapping( "weapon_glock", "weapon_aps" ),
    ItemMapping( "weapon_eagle", "weapon_groza" ),
    ItemMapping( "weapon_m16", "weapon_aks" ),
    ItemMapping( "weapon_saw", "weapon_rpk" ),
    ItemMapping( "weapon_shotgun", "weapon_spas12" ),
    ItemMapping( "weapon_rpg", "weapon_paranoia_rpg" ),
    ItemMapping( "weapon_handgrenade", "weapon_f1"),
    ItemMapping( "weapon_crowbar", "weapon_paranoia_knife"),
    ItemMapping( "weapon_knife", "weapon_paranoia_knife"),
    ItemMapping( "weapon_uzi", "weapon_paranoia_mp5"),
    ItemMapping( "weapon_sniperrifle", "weapon_val"),

    ItemMapping( "ammo_357", "ammo_grozaammobox"),
    ItemMapping( "ammo_556", "ammo_rpkammobox"),
    ItemMapping( "ammo_556clip", "ammo_rpk"),
    ItemMapping( "ammo_9mmAR" ,"ammo_ak74ammobox"),
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

dictionary dicAddItem = {
    {
        "restriction01",
        array<CMapAddItem@> = {
            CMapAddItem("ammo_apsammobox", array<Vector> = {
                Vector(452, -2117, -520),
                Vector(409, -2100, -520)
            })
        }
    },
    {
        "restriction02",
        array<CMapAddItem@> = {
            CMapAddItem("ammo_apsammobox", array<Vector> = {
                Vector(-537, -248, -638),
                Vector(-643, -248, -638),
                Vector(-716, -248, -638),
                Vector(-797, -248, -638),
                Vector(-1733., 980, -727),
                Vector(-1658., 980, -727),
                Vector(-1584., 980, -727),
                Vector(52, 945, -215),
                Vector(52, 869, -215)
            })
        }
    },
    {
        "restriction03",
        array<CMapAddItem@> = {
            CMapAddItem("ammo_grozaammobox", array<Vector> = {
                Vector(-1589, -1312, -411),
                Vector(-1494, -1251, -411),
                Vector(-272, -1123, -667),
                Vector(-567, -2130, -667),
                Vector(903, -1157, -414),
                Vector(1599, -1874, -667),
                Vector(1609, -1831, -667)
            }),
            CMapAddItem("ammo_apsammobox", array<Vector> = {
                Vector(-1682, -1240, -411),
                Vector(-1746, -1240, -411),
                Vector(-301, -1059, -667),
                Vector(-731, -861, -411),
                Vector(923, -1109, -414),
                Vector(1282, -2016, -1419),
                Vector(1652, -1873, -667)

            }),
            CMapAddItem("ammo_ak74ammobox", array<Vector> = {
                Vector(-269, -1000, -667),
                Vector(-566, -2101, -667),
                Vector(21, -2545, -411),
                Vector(32, -2582, -411),
                Vector(847, -1141, -414),
                Vector(1333, -1870, -667),
                Vector(1352, -1854, -667),
                Vector(1337, -1830, -667)

            }),
            CMapAddItem("weapon_ak74", array<Vector> = {
                Vector(-24, -2611, -411),
                Vector(1414, -1821, -667)
                
            }),
            CMapAddItem("item_healthkit", array<Vector> = {
                Vector(-756, -1108, -667),
                Vector(-773, -1028, -667),
                Vector(-762, -1535, -667),
                Vector(-245, -3021, -362),
                Vector(1278, -1537, -414),
                Vector(1425, -1867, -667),
                Vector(1466, -1882, -667)
            }),
            CMapAddItem("weapon_paranoia_mp5", array<Vector> = {
                Vector(906, -1596, -828)
            }),
            CMapAddItem("ammo_paranoia_mp5ammobox", array<Vector> = {
                Vector(953, -1607, -828),
                Vector(1008, -1607, -828)
            }),
        }
    } 
};

void MapInit(){
    RegisterPointCheckPointEntity();
    ControllerMapInit();
    WeaponRegister();
    g_ClassicMode.SetItemMappings( @g_ItemMappings );
    g_ClassicMode.ForceItemRemap( true );
}

void MapActivate(){
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
    if(dicAddItem.exists(g_Engine.mapname)){
        array<CMapAddItem@> aryItems = cast<array<CMapAddItem@>>(dicAddItem[g_Engine.mapname]);
        for(uint i = 0; i < aryItems.length(); i++){
            aryItems[i].Spawn();
        }
    }
}