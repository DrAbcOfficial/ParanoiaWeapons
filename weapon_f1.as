class weapon_f1 : CBaseParanoiaWeapon
{
    float flStartThrow;
    float flReleaseThrow;

    int iPinPullAnimation = 2;
    weapon_f1(){
        szVModel = "models/paranoia/v_grenade.mdl";
        szPModel = "models/paranoia/p_grenade.mdl";
        szWModel = "models/paranoia/w_grenadeammo.mdl";
        szShellModel = "models/paranoia/w_grenade.mdl";
        szHUDModel = "sprites/paranoia/p_hud7.spr";

        szAnimation = "gren";

        flDeploy = 1.0f;

        iDefaultGive = 5;
        iMaxAmmo1 = 3;
        iMaxClip = -1;
        iSlot = 6;
        iPosition = 9;
        iFlag = ITEM_FLAG_LIMITINWORLD | ITEM_FLAG_EXHAUSTIBLE;
        iWeight = 4;
        
        iDrawAnimation = 7;

        aryFireAnimation = {3, 4, 5};
        aryIdleAnimation = {0, 1};

        aryFireSound = {"weapons/paranoia/grenade-1.wav", "weapons/paranoia/grenade-1.wav"};
        aryOtherSound = {"weapons/paranoia/pinpull.wav", "weapons/paranoia/g_pinpull1.wav", "items/gunpickup2.wav"};
    }

    bool CanHolster(){
        return flStartThrow == 0;
    }

    void DestroyItem(){
        self.DestroyItem();
    }
    void Holster( int skiplocal /* = 0 */ ) override{
        self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + 0.5f;
        if(pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType) <= 0){
            pPlayer.pev.weapons &= ~(1<<WEAPON_HANDGRENADE);
            SetThink( ThinkFunction(DestroyItem) );
            pev.nextthink = g_Engine.time + 0.1f;
        }
    }

    void PrimaryAttack() override{
        if( flStartThrow <= 0 and pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType) > 0 ){
            flStartThrow = g_Engine.time;
            flReleaseThrow = 0;
            self.SendWeaponAnim(2);
            self.m_flTimeWeaponIdle = g_Engine.time + 0.5f;
        }
    }

    void WeaponIdle() override{
        if( flReleaseThrow == 0 and flStartThrow > 0 )
             flReleaseThrow = g_Engine.time;

        if( self.m_flTimeWeaponIdle > g_Engine.time )
            return;

        if( flStartThrow > 0 ){
            Vector angThrow = pPlayer.pev.v_angle + pPlayer.pev.punchangle;
            if( angThrow.x < 0 )
                angThrow.x = -10 + angThrow.x * ((90 - 10) / 90.0f);
            else
                angThrow.x = -10 + angThrow.x * (( 90 + 10) / 90.0f);

            float flVel = (90 - angThrow.x) * 4;
            if( flVel > 500 )
                flVel = 500;

            Math.MakeVectors( angThrow );
            Vector vecSrc = pPlayer.pev.origin + pPlayer.pev.view_ofs + g_Engine.v_forward * 16;
            Vector vecThrow = g_Engine.v_forward * flVel + pPlayer.pev.velocity;
            float time = flStartThrow - g_Engine.time + 3.0f;
            if( time < 0 )
                time = 0;

            CGrenade@ pGrenade = g_EntityFuncs.ShootTimed(pPlayer.pev, vecSrc, vecThrow, time);
            g_EntityFuncs.SetModel(pGrenade, szShellModel);
            pGrenade.pev.avelocity = Vector(15, 15, 15);

            if( flVel < 500 )
                self.SendWeaponAnim( aryFireAnimation[0] );
            else if( flVel < 1000 )
                self.SendWeaponAnim( aryFireAnimation[1] );
            else
                self.SendWeaponAnim( aryFireAnimation[2] );
            pPlayer.SetAnimation( PLAYER_ATTACK1 );

            flReleaseThrow = 0;
            flStartThrow = 0;
            self.m_flNextPrimaryAttack = g_Engine.time + 0.7f;
            self.m_flTimeWeaponIdle = g_Engine.time + 0.7f;
            pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType) - 1 );
            if( pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType) <= 0 )
                self.m_flTimeWeaponIdle = self.m_flNextSecondaryAttack = self.m_flNextPrimaryAttack = g_Engine.time + 0.5f;// ensure that the animation can finish playing
            return;
        }
        else if( flReleaseThrow > 0 )
        {
            flStartThrow = 0;
            if( pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType) > 0 )
                self.SendWeaponAnim( iDrawAnimation );
            else
            {
                self.RetireWeapon();
                return;
            }

            self.m_flTimeWeaponIdle = g_Engine.time + g_PlayerFuncs.SharedRandomFloat( pPlayer.random_seed, 10, 15 );
            flReleaseThrow = -1;
            return;
        }

        if( pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType) > 0 )
            self.SendWeaponAnim( aryIdleAnimation[Math.RandomLong(0, aryIdleAnimation.length()-1)] );
    }
}