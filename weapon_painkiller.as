class weapon_painkiller : CBaseParanoiaWeapon{
    weapon_painkiller(){
        szAnimation = "medkit";
        szSniperAnimation = "medkit";

        szWModel = "models/paranoia/w_painkiller.mdl";
        szHUDModel = "sprites/paranoia/p_hud2.spr";

        iDefaultGive = 1;
        iMaxAmmo1 = 5;
        iMaxClip = -1;
        iSlot = 0;
        iPosition = 6;
        iFlag = 0;
        iWeight = 0;
       
        aryFireSound = {"itmes/medshot4.wav"};
    }

    bool Deploy(){
        if(pPlayer.pev.health >= pPlayer.pev.max_health && pPlayer.m_bitsDamageType & DMG_TIMEBASED == 0)
            g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCENTER, "Your don't need to heal yourself yet!\n");
        else{
            g_PlayerFuncs.ScreenFade(pPlayer, Vector(124,225,251), 0.3, 0, 255, FFADE_IN | FFADE_MODULATE);
            pPlayer.TakeHealth(7, DMG_MEDKITHEAL);
            pPlayer.m_bitsDamageType &= ~DMG_TIMEBASED;
            pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType) - 1 );
            g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_ITEM, aryFireSound[0], 1.0, ATTN_NORM, 0, 95 + Math.RandomLong( 0, 10 ) );
            if(pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType) <= 0){
                pPlayer.pev.weapons &= ~(1<<WEAPON_HANDGRENADE);
                SetThink( ThinkFunction(DestroyItem) );
                pev.nextthink = g_Engine.time + 0.1f;
            }
        }
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
        g_Game.PrecacheGeneric( szWModel);
        g_Game.PrecacheModel( szHUDModel );
        g_Game.PrecacheGeneric( szHUDModel);
        g_Game.PrecacheGeneric( "sprites/" + szSprDir + "/" + self.pev.classname + ".txt");
    }

    void PrimaryAttack() override{
        BaseClass.PrimaryAttack();
    }

    void WeaponIdle(){
        BaseClass.WeaponIdle();
    }
    
    void SecondaryAttack() override{
        BaseClass.SecondaryAttack();
    }
}