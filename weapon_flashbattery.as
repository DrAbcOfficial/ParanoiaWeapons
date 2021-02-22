class weapon_flashbattery : CBaseParanoiaWeapon{
    weapon_flashbattery(){
        szAnimation = "medkit";
        szSniperAnimation = "medkit";

        szWModel = "models/paranoia/w_flashbattery.mdl";
        szHUDModel = "sprites/paranoia/p_hud1.spr";

        iDefaultGive = 1;
        iMaxAmmo1 = 7;
        iMaxClip = -1;
        iSlot = 0;
        iPosition = 7;
        iFlag = 0;
        iWeight = 0;
       
        aryFireSound = {"itmes/guncock1.wav"};
    }

    bool Deploy(){
       if(pPlayer.m_iFlashBattery < 100){
            aryPlayerBattery[pPlayer.entindex()] = 100;
            g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_ITEM, aryFireSound[0], 1.0, ATTN_NORM, 0, 95 + Math.RandomLong( 0, 10 ) );
            NetworkMessage message( MSG_ONE, NetworkMessages::ItemPickup, pPlayer.edict() );
                message.WriteString("flash_full");
            message.End();
            pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType, pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType) - 1);
            if(pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType) <= 0){
                pPlayer.pev.weapons &= ~(1<<WEAPON_HANDGRENADE);
                SetThink( ThinkFunction(DestroyItem) );
                pev.nextthink = g_Engine.time + 0.1f;
            }
        }
        else
            g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCENTER, "Your flash Battery is full!\n");
        pPlayer.SelectLastItem();
        return false;
	}

    void DestroyItem(){
        self.DestroyItem();
    }

    void Precache() override{
		for(uint i = 0; i < aryFireSound.length(); i++){
            g_SoundSystem.PrecacheSound( aryFireSound[i] );
        }
        g_Game.PrecacheModel( szWModel );
        g_Game.PrecacheModel( szHUDModel );
        g_Game.PrecacheGeneric( "sprites/" + szSprDir + "/" + self.pev.classname + ".txt");
    }

    void PrimaryAttack() override{
        return;
	}

    void WeaponIdle(){
        return;
    }
    
    void SecondaryAttack() override{
        return;
	}
}