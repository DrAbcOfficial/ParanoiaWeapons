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
            }),
            CMapAddItem("ammo_flashbattery", array<Vector> = {
                Vector(2017, 1075, -91),
                Vector(1996, 1112, -91),
                Vector(2067, -1657, -427),
                Vector(2834, -2840, -298)
            }),
            CMapAddItem("ammo_painkiller", array<Vector> = {
                Vector(1932, 1144, -91),
                Vector(1902, 1153, -91),
                Vector(2162, -1660, -427)
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
            }),
            CMapAddItem("ammo_flashbattery", array<Vector> = {
                Vector(564, -1939, -375),
				Vector(599, -1932, -375),
				Vector(-489, -603, -638)
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
            CMapAddItem("ammo_flashbattery", array<Vector> = {
                Vector(-1454, -1381, -411),
                Vector(-790, -1082, -411),
                Vector(-1181, -1380, -411),
                Vector(-262, -2268, -380),
                Vector(1295, -1509, -414),
                Vector(1172, -2100, -1419),
				Vector(1242, -2112, -1419)

            }),
            CMapAddItem("ammo_painkiller", array<Vector> = {
                Vector(-1451, -1324, -411),
                Vector(-1147, -1420, -411)

            }) 
        }
    },
    {
        "restriction04",
        array<CMapAddItem@> = {
            CMapAddItem("ammo_painkiller", array<Vector> = {
                Vector(-1601, 1637, 180),
				Vector(-1601, 1567, 180),
				Vector(-238, 222, 128),
				Vector(-228, 187, 128),
				Vector(-1349, 1565, 244),
				Vector(592, 3496, 514),
				Vector(1663, 3570, 514),
				Vector(1332, 439, 163),
				Vector(1337, 464, 163)
            }),
            CMapAddItem("ammo_flashbattery", array<Vector> = {
                Vector(-1311, 1622, 244),
                Vector(1612, 3621, 514),
                Vector(-962, -1463, 156)
            }),
            CMapAddItem("ammo_spas12", array<Vector> = {
                Vector(-1158, 1515, 244),
				Vector(-1154, 1552, 244),
				Vector(1600, 3660, 514),
				Vector(-839, -1455, 156),
				Vector(-839, -1523, 156)

            }),
            CMapAddItem("ammo_apsammobox", array<Vector> = {
                Vector(861, 2825, 386),
                Vector(1257, 416, 156)

            }),
            CMapAddItem("ammo_ak74ammobox", array<Vector> = {
                Vector(811, 2834, 386),
				Vector(746, 2830, 386)

            }),
            CMapAddItem("ammo_aksammobox", array<Vector> = {
                Vector(851, 964, 118),
				Vector(857, 1000, 145)

            }),
            CMapAddItem("ammo_grozaammobox", array<Vector> = {
                Vector(1870, 291, 616),
				Vector(1947, 254, 616),
				Vector(531, 3557, 514),
				Vector(541, 3626, 514)
            })
        }
    },
    {
        "restriction05",
        array<CMapAddItem@> = {
            CMapAddItem("ammo_painkiller", array<Vector> = {
            	Vector(-1209, -2765, 198),
				Vector(-1210, -2815, 198)

            }),
            CMapAddItem("ammo_flashbattery", array<Vector> = {
            	Vector(-2460, -2923, 217)
            }),
            CMapAddItem("ammo_spas12", array<Vector> = {
            	Vector(-2451, -2934, 217)

            }),
            CMapAddItem("weapon_aps", array<Vector> = {
            	Vector(-1810, -3399, 219)

            }),
            CMapAddItem("weapon_aks", array<Vector> = {
            	Vector(-565, 3286, -519),
            	Vector(850, 1947, -539),
				Vector(912, 1938, -539)

            }),
            CMapAddItem("ammo_apsammobox", array<Vector> = {
            	Vector(-1809, -3436, 219)

            }),
            CMapAddItem("ammo_ak74ammobox", array<Vector> = {
                Vector(-402, -1540, -7),
				Vector(-357, -1551, -7),
				Vector(-492, 3210, -539),
				Vector(-511, 3148, -539)

            }),
            CMapAddItem("ammo_aksammobox", array<Vector> = {
            	Vector(-1224, -1801, 19),
				Vector(-1254, -1821, 19),
				Vector(-82, 1122, -543),
				Vector(-52, 1081, -543),
				Vector(-94, 1056, -543)

            }),
            CMapAddItem("ammo_grozaammobox", array<Vector> = {
            	Vector(-380, -1749, 39),
            	Vector(-396, 3123, -539),
				Vector(-457, 3165, -539),
				Vector(-81, 1055, -543),
				Vector(-50, 1052, -543)

            }),
            CMapAddItem("item_healthkit", array<Vector> = {
                Vector(52, 1532, -396),
				Vector(-11, 1512, -396)
            })
        }
    },
    {
        "restriction06",
        array<CMapAddItem@> = {
            CMapAddItem("ammo_painkiller", array<Vector> = {
            	Vector(658, 1140, -1132),
            	Vector(-570, 1410, -1092),
				Vector(-497, 1416, -1092),
				Vector(-934, -214, -1131),
				Vector(-934, -167, -1131)
            }),
            CMapAddItem("ammo_flashbattery", array<Vector> = {
            	Vector(657, 1195, -1132),
				Vector(657, 1233, -1132),
				Vector(-1018, -154, -1131)

            }),
            CMapAddItem("ammo_spas12", array<Vector> = {
            	Vector(-512, 1476, -1092)
            }),
            CMapAddItem("ammo_apsammobox", array<Vector> = {
            	Vector(-544, 1456, -1092),
				Vector(-558, 1451, -1092),
				Vector(-1035, -273, -1131)
            }),
            CMapAddItem("ammo_ak74ammobox", array<Vector> = {
                Vector(2634, -1289, -1383),
				Vector(2634, -1342, -1383)
            }),
            CMapAddItem("ammo_aksammobox", array<Vector> = {
            	Vector(-1100, -276, -1131),
				Vector(-1056, -350, -1131),
				Vector(279, 2199, -1491),
				Vector(243, 2173, -1491),
				Vector(208, 2168, -1491)
            }),
            CMapAddItem("ammo_grozaammobox", array<Vector> = {
            	Vector(562, 1049, -1131),
				Vector(635, 1079, -1132),
				Vector(-1113, -273, -1131),
				Vector(-1085, -317, -1131),
				Vector(2633, -1160, -1383)
            }),
            CMapAddItem("item_healthkit", array<Vector> = {
               	Vector(2382, -1336, -1380),
				Vector(2394, -1310, -1380)
            })
        }
    },
    {
        "restriction07",
        array<CMapAddItem@> = {
            CMapAddItem("ammo_painkiller", array<Vector> = {
            	Vector(-595, 749, -1902),
				Vector(-595, 702, -1929),
				Vector(-2262, 1876, -3667),
				Vector(-2320, 1876, -3667)
            }),
            CMapAddItem("ammo_flashbattery", array<Vector> = {
            	Vector(-775, 871, -1924),
				Vector(-775, 849, -1924),
				Vector(-986, 411, -1663),
				Vector(-929, 411, -1663),
				Vector(-2247, 2043, -3667),
				Vector(-2289, 2043, -3667)
            }),
            CMapAddItem("ammo_f1", array<Vector> = {
            	Vector(-778, 862, -1924)
            }),

            CMapAddItem("ammo_apsammobox", array<Vector> = {
            	Vector(-714, 856, -1933),
				Vector(-682, 854, -1933),
				Vector(-733, 839, -1933)
            }),
            CMapAddItem("ammo_aksammobox", array<Vector> = {
            	Vector(-2270, 1951, -3667),
				Vector(-2290, 1909, -3667)
            }),
            CMapAddItem("ammo_grozaammobox", array<Vector> = {
            	Vector(-839, 852, -1924),
				Vector(-837, 866, -1924)
            })
        }
    },
    {
        "restriction08",
        array<CMapAddItem@> = {
            CMapAddItem("ammo_painkiller", array<Vector> = {
            	Vector(-677, 723, 100),
				Vector(-676, 676, 100)
            }),
            CMapAddItem("ammo_flashbattery", array<Vector> = {
            	Vector(-2503, -691, 116),
				Vector(-2524, -727, 116),
				Vector(1342, 158, 136),
				Vector(1402, 182, 136)
            }),
            CMapAddItem("weapon_val", array<Vector> = {
            	Vector(-427, -2481, -336)
            }),
            CMapAddItem("ammo_val", array<Vector> = {
            	Vector(-390, -2338, -346),
				Vector(-415, -2312, -346)
            }),
            CMapAddItem("weapon_paranoia_mp5", array<Vector> = {
            	Vector(-3403, -82, 116)
            }),
            CMapAddItem("ammo_paranoia_mp5ammobox", array<Vector> = {
            	Vector(-3383, -10, 116),
				Vector(-3401, 52, 116)
            }),
            CMapAddItem("ammo_glockammobox", array<Vector> = {
            	Vector(-686, 633, -159),
				Vector(-716, 637, -159)
            }),
            CMapAddItem("ammo_apsammobox", array<Vector> = {
            	Vector(-3386, 821, -340),
				Vector(-3347, 847, -340)
            }),
            CMapAddItem("ammo_aksammobox", array<Vector> = {
            	Vector(-3321, 979, -340),
				Vector(-3284, 1003, -340),
				Vector(-3269, 971, -340)
            }),
            CMapAddItem("ammo_grozaammobox", array<Vector> = {
            	Vector(-3551, 948, -340),
				Vector(-3543, 936, -340),
				Vector(-3577, 918, -340)
            })
        }
    },
    {
        "restriction09",
        array<CMapAddItem@> = {
            CMapAddItem("ammo_painkiller", array<Vector> = {
            	Vector(1418, 2042, 38),
            	Vector(-798, 1675, -72),
				Vector(-822, 1644, -72),
				Vector(-781, 1650, -72)
            }),
            CMapAddItem("ammo_flashbattery", array<Vector> = {
            	Vector(1406, 1871, 78),
				Vector(1404, 1906, 105)
            }),
            CMapAddItem("ammo_apsammobox", array<Vector> = {
            	Vector(-1390, 2355, 55),
            	Vector(-736, 1619, -72),
            	Vector(-756, 1579, -72)
            }),
            CMapAddItem("ammo_spas12", array<Vector> = {
            	Vector(-1520, 2276, 55),
				Vector(-1479, 2262, 55),
				Vector(-1517, 2297, 55)
            }),
            CMapAddItem("ammo_aksammobox", array<Vector> = {
            	Vector(641, 2642, 99),
				Vector(678, 2656, 99),
				Vector(-742, 1557, -72),
				Vector(-729, 1593, -72),
				Vector(-683, 1589, -72),
				Vector(-421, 78, 36),
				Vector(-476, 65, 36),
				Vector(-523, 33, 36)
            }),
            CMapAddItem("ammo_grozaammobox", array<Vector> = {
            	Vector(-1361, 2381, 55),
				Vector(-1408, 2380, 55)
            })
        }
    },
    {
        "restriction10",
        array<CMapAddItem@> = {
            CMapAddItem("ammo_painkiller", array<Vector> = {
            	Vector(198, -1021, 389),
				Vector(230, -1004, 389),
				Vector(1322, 508, 582),
				Vector(1340, 508, 582),
				Vector(1342, 495, 582)
            }),
            CMapAddItem("ammo_flashbattery", array<Vector> = {
            	Vector(-224, 282, 444),
				Vector(-288, 282, 444),
				Vector(1333, 312, 548)
            }),
            CMapAddItem("ammo_apsammobox", array<Vector> = {
				Vector(178, -1180, 389),
				Vector(239, -1180, 389),
				Vector(1505, 442, 548),
				Vector(1509, 402, 548),
				Vector(1494, 392, 548)
            }),
            CMapAddItem("ammo_spas12", array<Vector> = {
            	Vector(-196, 217, 432),
				Vector(-225, 220, 432),
				Vector(-240, 194, 432),
				Vector(1459, 449, 548),
				Vector(1505, 451, 548)
            }),
            CMapAddItem("ammo_aksammobox", array<Vector> = {
            	Vector(-16, 213, 432),
				Vector(-57, 211, 432),
				Vector(1208, 469, 582),
				Vector(1202, 508, 582)
            })
        }
    },
};

void MapInit(){
    RegisterPointCheckPointEntity();
    ControllerMapInit();
    WeaponRegister();
    BatteryHookRegister();
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
    string szMapName = string(g_Engine.mapname).ToLowercase();
    if(dicAddItem.exists(szMapName)){
        array<CMapAddItem@> aryItems = cast<array<CMapAddItem@>>(dicAddItem[szMapName]);
        for(uint i = 0; i < aryItems.length(); i++){
            aryItems[i].Spawn();
        }
    }
}