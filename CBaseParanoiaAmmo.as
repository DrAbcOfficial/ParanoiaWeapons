abstract class CBaseParanoiaAmmo : ScriptBasePlayerAmmoEntity{
    protected string szModel = "";
    protected string szAmmo = "";
    protected int iGive = 0;
    protected int iMax = 0;
	void Spawn(){ 
		Precache();
		g_EntityFuncs.SetModel( self, szModel );
		BaseClass.Spawn();
		g_EntityFuncs.SetSize(self.pev, Vector( -4, -4, -1 ), Vector( 4, 4, 1 ));
	}
	
	void Precache(){
		BaseClass.Precache();
		g_Game.PrecacheModel( szModel );
		g_SoundSystem.PrecacheSound("items/9mmclip1.wav");
	}
	
	bool AddAmmo( CBaseEntity@ pOther ) { 
		if (pOther.GiveAmmo( iGive, szAmmo, iMax ) != -1){
			g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM);
			return true;
		}
		return false;
	}
}

void ParanoiaAmmoRegister(string szClassName, string szName){
    g_CustomEntityFuncs.RegisterCustomEntity( szClassName, szName);
    g_Game.PrecacheOther(szName);
}

class ammo_ak74 : CBaseParanoiaAmmo{
    ammo_ak74(){
        szModel = "models/paranoia/w_ak74ammo.mdl";
        szAmmo = "7Н6";
        iGive = 30;
        iMax = 120;
    }
}

class ammo_ak74ammobox : CBaseParanoiaAmmo{
    ammo_ak74ammobox(){
        szModel = "models/paranoia/w_ak74ammobox.mdl";
        szAmmo = "7Н6";
        iGive = 90;
        iMax = 120;
    }
}

class ammo_aks : CBaseParanoiaAmmo{
    ammo_aks(){
        szModel = "models/paranoia/w_aksammo.mdl";
        szAmmo = "7Н6";
        iGive = 30;
        iMax = 120;
    }
}

class ammo_aksammobox : CBaseParanoiaAmmo{
    ammo_aksammobox(){
        szModel = "models/paranoia/w_aksammobox.mdl";
        szAmmo = "7Н6";
        iGive = 90;
        iMax = 120;
    }
}

class ammo_aps : CBaseParanoiaAmmo{
    ammo_aps(){
        szModel = "models/paranoia/w_apsammo.mdl";
        szAmmo = "57-Н-181";
        iGive = 10;
        iMax = 90;
    }
}

class ammo_apsammobox : CBaseParanoiaAmmo{
    ammo_apsammobox(){
        szModel = "models/paranoia/w_apsammobox.mdl";
        szAmmo = "57-Н-181";
        iGive = 20;
        iMax = 90;
    }
}

class ammo_glock : CBaseParanoiaAmmo{
    ammo_glock(){
        szModel = "models/paranoia/w_glockammo.mdl";
        szAmmo = "9mm";
        iGive = 20;
        iMax = 600;
    }
}

class ammo_glockammobox : CBaseParanoiaAmmo{
    ammo_glockammobox(){
        szModel = "models/paranoia/w_glockammobox.mdl";
        szAmmo = "9mm";
        iGive = 60;
        iMax = 600;
    }
}

class ammo_groza : CBaseParanoiaAmmo{
    ammo_groza(){
        szModel = "models/paranoia/w_grammo.mdl";
        szAmmo = "7Н8";
        iGive = 20;
        iMax = 80;
    }
}

class ammo_grozaammobox : CBaseParanoiaAmmo{
    ammo_grozaammobox(){
        szModel = "models/paranoia/w_grammobox.mdl";
        szAmmo = "7Н8";
        iGive = 60;
        iMax = 80;
    }
}

class ammo_paranoia_mp5 : CBaseParanoiaAmmo{
    ammo_paranoia_mp5(){
        szModel = "models/paranoia/w_mp5ammo.mdl";
        szAmmo = "9mm";
        iGive = 30;
        iMax = 600;
    }
}

class ammo_paranoia_mp5ammobox : CBaseParanoiaAmmo{
    ammo_paranoia_mp5ammobox(){
        szModel = "models/paranoia/w_mp5ammobox.mdl";
        szAmmo = "9mm";
        iGive = 90;
        iMax = 600;
    }
}

class ammo_rpk : CBaseParanoiaAmmo{
    ammo_rpk(){
        szModel = "models/paranoia/w_rpkammo.mdl";
        szAmmo = "57-Н-323С";
        iGive = 150;
        iMax = 450;
    }
}

class ammo_rpkammobox : CBaseParanoiaAmmo{
    ammo_rpkammobox(){
        szModel = "models/paranoia/w_rpkammobox.mdl";
        szAmmo = "57-Н-323С";
        iGive = 300;
        iMax = 450;
    }
}

class ammo_spas12 : CBaseParanoiaAmmo{
    ammo_spas12(){
        szModel = "models/paranoia/w_spas12_ammo.mdl";
        szAmmo = "buckshot";
        iGive = 8;
        iMax = 120;
    }
}

class ammo_val : CBaseParanoiaAmmo{
    ammo_val(){
        szModel = "models/paranoia/w_valammo.mdl";
        szAmmo = "7Н8";
        iGive = 20;
        iMax = 120;
    }
}

class ammo_valammobox : CBaseParanoiaAmmo{
    ammo_valammobox(){
        szModel = "models/paranoia/w_valammobox.mdl";
        szAmmo = "7Н8";
        iGive = 60;
        iMax = 80;
    }
}

class ammo_paranoia_rpg : CBaseParanoiaAmmo{
    ammo_paranoia_rpg(){
        szModel = "models/paranoia/w_rpg_ammo.mdl";
        szAmmo = "rockets";
        iGive = 1;
        iMax = 5;
    }
}

class ammo_f1 : CBaseParanoiaAmmo{
    ammo_f1(){
        szModel = "models/paranoia/w_grenadeammo.mdl";
        szAmmo = "f1";
        iGive = 1;
        iMax = 5;
    }

    bool AddAmmo( CBaseEntity@ pOther ) override { 
        CBasePlayer@ pPlayer = cast<CBasePlayer@>(@pOther);
        if(@pPlayer !is null && pPlayer.HasNamedPlayerItem("weapon_f1") is null){
            pPlayer.GiveNamedItem("weapon_f1");
            return true;
        }
		else if (pOther.GiveAmmo( iGive, szAmmo, iMax ) != -1){
			g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM);
			return true;
		}
		return false;
	}
}

class ammo_painkiller : CBaseParanoiaAmmo{
    ammo_painkiller(){
        szModel = "models/paranoia/w_painkiller.mdl";
        szAmmo = "painkiller";
        iGive = 1;
        iMax = 5;
    }

    bool AddAmmo( CBaseEntity@ pOther ) override { 
        CBasePlayer@ pPlayer = cast<CBasePlayer@>(@pOther);
        if(@pPlayer !is null && pPlayer.HasNamedPlayerItem("weapon_painkiller") is null){
            pPlayer.GiveNamedItem("weapon_painkiller");
            return true;
        }
		else if (pOther.GiveAmmo( iGive, szAmmo, iMax ) != -1){
			g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM);
			return true;
		}
		return false;
	}
}

class ammo_flashbattery : CBaseParanoiaAmmo{
    ammo_flashbattery(){
        szModel = "models/paranoia/w_flashbattery.mdl";
        szAmmo = "flashbattery";
        iGive = 1;
        iMax = 7;
    }

    bool AddAmmo( CBaseEntity@ pOther ) override { 
        CBasePlayer@ pPlayer = cast<CBasePlayer@>(@pOther);
        if(@pPlayer !is null && pPlayer.HasNamedPlayerItem("weapon_flashbattery") is null){
            pPlayer.GiveNamedItem("weapon_flashbattery");
            return true;
        }
		else if (pOther.GiveAmmo( iGive, szAmmo, iMax ) != -1){
			g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM);
			return true;
		}
		return false;
	}
}