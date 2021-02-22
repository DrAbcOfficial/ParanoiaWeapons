class weapon_spas12 : CBaseParanoiaWeapon{
    weapon_spas12(){
        szVModel = "models/paranoia/v_spas12.mdl";
        szPModel = "models/paranoia/p_spas12.mdl";
        szWModel = "models/paranoia/w_spas12.mdl";
        szShellModel = "models/paranoia/spas12_shell.mdl";

        szAnimation = "shotgun";

        flDeploy = 1.1f;
        flShock = 30.0f;
        flReloadTime = 0.6f;
        flIronReloadTime = 0.6f;
        flPrimaryTime = 1.20f;
        flSccenaryTime = 0.31f;
        flIdleTime = 1.2f;

        iDamage = 16;
        iDefaultGive = 24;
        iMaxAmmo1 = 48;
        iMaxClip = 8;
        iSlot = 3;
        iPosition = 11;
        iFlag = 0;
        iWeight = 4;
        iFOV = 70;
        iMoveSpeed = 220;
        
        vecEjectOrigin = Vector(6, 18, -6);
        vecIronEjectOrigin = Vector(6, 18, -6);
        iShellSound = TE_BOUNCE_SHOTSHELL;
        vecAccurency = Vector(0.08716, 0.04362, 0);
        vecIronAccurency = Vector(0.08716, 0.04362, 0);

        vec2XPunch = Vector2D(-2, 2);
        vec2YPunch = Vector2D(-4, 4);

        iDrawAnimation = 6;
        iReloadAnimation = 5;
        iIronReloadAnimation = 13;
        iChangeAnimation = 8;
        iReChangeAnimation = 7;

        aryFireAnimation = {1, 2};
        aryIronFireAnimation = {10, 11};
        aryIdleAnimation = {0};
        aryIronIdleAnimation = {9};

        aryFireSound = {"weapons/paranoia/spas12-1.wav", "weapons/paranoia/spas12-1.wav"};
        aryOtherSound = {"weapons/paranoia/spas12_insertshell.wav", "weapons/paranoia/spas12_pump.wav"};
    }

    private int iInsertAnimation = 3;
    private int iAfterReloadAnimation = 4;
    private int iIronAfterReloadAnimation = 12;
    private float flPumpTime = 0.6;
    private float flPumpNextTime = 0;
    private float flReloadNextTime = 0;
    private float flInsertReloadTime = 0.55;
    private bool bShouldPump = false;
    private bool bShouldReload = false;
    private int iPellet = 8;

    void ItemPostFrame(){
		if( flPumpNextTime != 0 && flPumpNextTime < g_Engine.time && bShouldPump ){
            Vector vecShellOffset = bIron ? vecIronEjectOrigin : vecEjectOrigin;
            Vector vecShellOrigin = g_Engine.v_right * vecShellOffset.x + g_Engine.v_forward * vecShellOffset.y + g_Engine.v_up * vecShellOffset.z;

            g_EntityFuncs.EjectBrass( 
                pPlayer.GetGunPosition() + vecShellOrigin, 
                g_Engine.v_right * Math.RandomLong(80,160) + g_Engine.v_forward * Math.RandomLong(-20,80) + pPlayer.pev.velocity, 
                pPlayer.pev.angles[1], 
                iShell, 
                iShellSound );
			bShouldPump = false;
		}
		BaseClass.ItemPostFrame();
	}

    void PrimaryAttack() override{
        if(!bCanAutoFire && bAutoFlag){
            return;
        }

		if(self.m_iClip <= 0 ){
			self.PlayEmptySound();
			self.m_flNextPrimaryAttack = g_Engine.time + 0.15f;
			return;
		}
		
		self.m_flTimeWeaponIdle = g_Engine.time + flIdleTime;
        self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + flPrimaryTime;

		self.m_iClip--;
        bAutoFlag = true;
		
		pPlayer.pev.effects |= EF_MUZZLEFLASH;
		pPlayer.m_iWeaponVolume = LOUD_GUN_VOLUME;
		pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;
		pPlayer.SetAnimation( PLAYER_ATTACK1 );

        array<int>@ aryAnimation = bIron ? aryIronFireAnimation : aryFireAnimation;
        int iAniIndex = self.m_iClip != 0 && aryAnimation.length() > 1 ? g_PlayerFuncs.SharedRandomLong(pPlayer.random_seed, 0, aryAnimation.length()-2) : aryAnimation.length() - 1;
        self.SendWeaponAnim(aryAnimation[iAniIndex], 0, 0);

		g_SoundSystem.EmitSoundDyn( pPlayer.edict(), CHAN_WEAPON, 
            aryFireSound[g_PlayerFuncs.SharedRandomLong(pPlayer.random_seed, 0, aryFireSound.length() - 1)], 
            0.9, ATTN_NORM, 0, PITCH_NORM );
		
		Vector vecSrc = pPlayer.GetGunPosition();
		Vector vecAiming = pPlayer.GetAutoaimVector( AUTOAIM_5DEGREES );
        Vector vecAcc = bIron ? vecIronAccurency : vecAccurency;

		pPlayer.FireBullets(iPellet, vecSrc, vecAiming, vecAcc, 8192, BULLET_PLAYER_CUSTOMDAMAGE, 2, iDamage + int(Math.RandomFloat(vecDamageDrift.x, vecDamageDrift.y)));

        NetworkMessage m(MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null);
            m.WriteByte(TE_DLIGHT);
            m.WriteCoord(vecSrc.x);
            m.WriteCoord(vecSrc.y);
            m.WriteCoord(vecSrc.z);
            m.WriteByte(32);
            m.WriteByte(255);
            m.WriteByte(255);
            m.WriteByte(34);
            m.WriteByte(1);
            m.WriteByte(255);
        m.End();

		if( self.m_iClip == 0 && pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			pPlayer.SetSuitUpdate( "!HEV_AMO0", false, 0 );
		
		pPlayer.pev.punchangle.x += Math.RandomFloat( vec2XPunch.x, vec2XPunch.y );
        pPlayer.pev.punchangle.y += Math.RandomFloat( vec2YPunch.x, vec2YPunch.y );

        bShouldPump = true;
        bShouldReload = false;
        flPumpNextTime = g_Engine.time + flPumpTime;

        for(int i = 0; i < iPellet; i++){
            TraceResult tr;
            float x, y;
            g_Utility.GetCircularGaussianSpread( x, y );
            Vector vecEnd = vecSrc + (vecAiming + x * vecAcc.x * g_Engine.v_right + y * vecAcc.y * g_Engine.v_up) * 8192;
            g_Utility.TraceLine( vecSrc, vecEnd, dont_ignore_monsters, pPlayer.edict(), tr );
            
            if( tr.flFraction < 1.0 ){
                if( tr.pHit !is null ){
                    CBaseEntity@ pHit = g_EntityFuncs.Instance( tr.pHit );
                    if (pHit is null || pHit.IsBSPModel())
                        g_WeaponFuncs.DecalGunshot( tr, BULLET_PLAYER_MP5 );
                    else if(pHit.IsMonster() && pHit.IRelationship(pPlayer) > R_NO){
                        Vector vecPos = (tr.vecEndPos - vecSrc).Normalize();
                        vecPos.z = 0;
                        pHit.pev.velocity = pHit.pev.velocity + vecPos * flShock + g_Engine.v_up * flShock;
                    }
                }
            }
        }
    }

    void FinishReload() override{
        BaseClass.FinishReload();
    }

    void Reload() override{
        if( pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 || self.m_iClip >= iMaxClip )
			return;
		if( flReloadNextTime > g_Engine.time )
			return;
		if( self.m_flNextPrimaryAttack > g_Engine.time && !bShouldReload )
			return;
		if(bShouldReload){
			if( self.m_iClip >= iMaxClip ){
				bShouldReload = false;
				return;
			}
			self.SendWeaponAnim( iInsertAnimation, 0 );
			flReloadNextTime = self.m_flTimeWeaponIdle = g_Engine.time + flInsertReloadTime;
			self.m_iClip++;
			pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) - 1 );
            pPlayer.SetAnimation(PLAYER_RELOAD);
		}
		else{
            if(bIron){
                ToggleZoom( 0 );
                pPlayer.m_szAnimExtension = szAnimation;
            }
            self.SendWeaponAnim( bIron ? iIronReloadAnimation : iReloadAnimation, 0, 0 );
            pPlayer.m_flNextAttack = (bIron ? flIronReloadTime : flReloadTime);
			self.m_flTimeWeaponIdle = g_Engine.time + (bIron ? flIronReloadTime : flReloadTime);
            self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + (bIron ? flIronReloadTime : flReloadTime)  + 0.1;
			bShouldReload = true;
            pPlayer.SetAnimation(PLAYER_RELOAD);
			return;
		}
    }

    void WeaponIdle() override{
		self.ResetEmptySound();
		if( self.m_flTimeWeaponIdle < g_Engine.time ){
			if( self.m_iClip <= 0 && !bShouldReload && pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) != 0 )
				self.Reload();
			else if(bShouldReload){
				if( self.m_iClip < iMaxClip && pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) > 0)
					self.Reload();
				else{
					self.SendWeaponAnim( bIron ? iIronAfterReloadAnimation : iAfterReloadAnimation, 0, 0 );
					bShouldReload = false;
                     if(bIron){
                        ToggleZoom( iFOV );
                        pPlayer.m_szAnimExtension = szSniperAnimation;
                    }
					self.m_flTimeWeaponIdle = g_Engine.time + 1.5;
				}
			}
			else{
                array<int>@ aryAnimation = bIron ? aryIronIdleAnimation : aryIdleAnimation;
                self.SendWeaponAnim( aryAnimation[Math.RandomLong(0, aryAnimation.length() - 1)], 0, 0 );
            }
		}
	}
}