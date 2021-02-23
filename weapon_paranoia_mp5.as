class weapon_paranoia_mp5 : CBaseParanoiaWeapon{
    weapon_paranoia_mp5(){
        szVModel = "models/paranoia/v_9mmar.mdl";
        szPModel = "models/paranoia/p_9mmar.mdl";
        szWModel = "models/paranoia/w_9mmar.mdl";
        szShellModel = "models/paranoia/glock_shell.mdl";
        szHUDModel = "sprites/paranoia/p_hud3.spr";

        szAnimation = "mp5";

        flDeploy = 0.77f;
        flReloadTime = 3.5f;
        flIronReloadTime = 3.5f;
        flPrimaryTime = 0.1f;
        flSccenaryTime = 3.1f;
        flIdleTime = 0.52f;

        iDamage = 12;
        iDefaultGive = 90;
        iMaxAmmo1 = 600;
        iMaxAmmo2 = 5;
        iMaxClip = 30;
        iSlot = 4;
        iPosition = 13;
        iFlag = 0;
        iWeight = 4;

        vecEjectOrigin = Vector(6, 18, -6);
        vecIronEjectOrigin = Vector(6, 18, -6);
        vecAccurency = VECTOR_CONE_4DEGREES;
        vecIronAccurency = VECTOR_CONE_2DEGREES;

        vec2XPunch = Vector2D(-2, 2);
        vec2YPunch = Vector2D(-2, 2);

        iDrawAnimation = 3;
        iReloadAnimation = 8;
        iIronReloadAnimation = 8;

        aryFireAnimation = {4};
        aryIronFireAnimation = {5, 6};
        aryIdleAnimation = {0, 1};
        aryIronIdleAnimation = {0, 1};

        aryFireSound = {"weapons/paranoia/hks1.wav", "weapons/paranoia/hks2.wav"};
        aryOtherSound = {"weapons/paranoia/hks_draw.wav", "weapons/paranoia/hks_02.wavv", 
            "weapons/paranoia/hks_pinpull.wav", "weapons/paranoia/hks_m203_in.wav",
            "weapons/paranoia/hks_01.wav", "weapons/paranoia/hks_clipout.wav", 
            "weapons/paranoia/hks_clipin.wav", "weapons/paranoia/hks_boltslap.wav", "weapons/glauncher.wav"};
    }
    void SecondaryAttack(){
        if( pPlayer.pev.waterlevel == WATERLEVEL_HEAD ){
            self.PlayEmptySound();
            self.m_flNextPrimaryAttack = g_Engine.time + 0.15;
            return;
        }
        
        if( pPlayer.m_rgAmmo(self.m_iSecondaryAmmoType) <= 0 ){
            self.PlayEmptySound();
            return;
        }


        pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
        pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

        pPlayer.m_iExtraSoundTypes = bits_SOUND_DANGER;
        pPlayer.m_flStopExtraSoundTime = g_Engine.time + 0.2;

        pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType, pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType ) - 1 );

        pPlayer.pev.punchangle.x = -10.0;
        self.SendWeaponAnim(pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType) <= 0 ? 6 : 5);
        pPlayer.SetAnimation( PLAYER_ATTACK1 );
        g_SoundSystem.EmitSoundDyn( pPlayer.edict(), CHAN_WEAPON, "weapons/glauncher.wav", 0.8, ATTN_NORM, 0, PITCH_NORM );
        Math.MakeVectors( pPlayer.pev.v_angle + pPlayer.pev.punchangle );

        if( ( pPlayer.pev.button & IN_DUCK ) != 0 ){
            g_EntityFuncs.ShootContact( pPlayer.pev, 
                                pPlayer.pev.origin + g_Engine.v_forward * 16 + g_Engine.v_right * 6, 
                                g_Engine.v_forward * 900 ); //800
        }
        else{
            g_EntityFuncs.ShootContact( pPlayer.pev, 
                                pPlayer.pev.origin + pPlayer.pev.view_ofs * 0.5 + g_Engine.v_forward * 16 + g_Engine.v_right * 6, 
                                g_Engine.v_forward * 900 ); //800
        }
        self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + (pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType) <= 0 ? 0.6 : flSccenaryTime);
        self.m_flTimeWeaponIdle = g_Engine.time + flSccenaryTime;
        if( pPlayer.m_rgAmmo(self.m_iSecondaryAmmoType) <= 0 )
            pPlayer.SetSuitUpdate( "!HEV_AMO0", false, 0 );
    }
}