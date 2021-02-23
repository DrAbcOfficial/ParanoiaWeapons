class weapon_paranoia_knife : CBaseParanoiaWeapon{
    int iSwing;
    TraceResult pHitTrace;
    
    weapon_paranoia_knife(){
        szVModel = "models/paranoia/v_crowbar.mdl";
        szPModel = "models/paranoia/p_crowbar.mdl";
        szWModel = "models/paranoia/w_crowbar.mdl";
        szHUDModel = "sprites/paranoia/p_hud2.spr";

        szAnimation = "crowbar";

        flDeploy = 1.0f;

        iDefaultGive = 0;
        iMaxAmmo1 = -1;
        iMaxClip = -1;
        iSlot = 1;
        iPosition = 7;
        
        iDrawAnimation = 5;

        aryFireAnimation = {1, 2, 3, 4};
        aryIdleAnimation = {0};

        aryFireSound = {"weapons/paranoia/knife_stab.wav"};
        aryOtherSound = {"weapons/paranoia/knife_deploy1.wav", };
    }

    void PrimaryAttack() override{
        Swing(1);
    }

    void SecondaryAttack() override{
        Swing(1, false, 0.8);
    }
    
    void Smack(){
        g_WeaponFuncs.DecalGunshot( pHitTrace, BULLET_PLAYER_CROWBAR );
    }


    bool Swing( int fFirst , bool bIsPrimary = true, float flNextAttack = 0.5){
        bool fDidHit = false;
        TraceResult tr;
        Math.MakeVectors( pPlayer.pev.v_angle );
        Vector vecSrc    = pPlayer.GetGunPosition();
        Vector vecEnd    = vecSrc + g_Engine.v_forward * 32;
        g_Utility.TraceLine( vecSrc, vecEnd, dont_ignore_monsters, pPlayer.edict(), tr );
        if ( tr.flFraction >= 1.0 ){
            g_Utility.TraceHull( vecSrc, vecEnd, dont_ignore_monsters, head_hull, pPlayer.edict(), tr );
            if ( tr.flFraction < 1.0 ){
                CBaseEntity@ pHit = g_EntityFuncs.Instance( tr.pHit );
                if ( pHit is null || pHit.IsBSPModel() )
                    g_Utility.FindHullIntersection( vecSrc, tr, tr, VEC_DUCK_HULL_MIN, VEC_DUCK_HULL_MAX, pPlayer.edict() );
                vecEnd = tr.vecEndPos;
            }
        }

        //写人人都看得懂的工程代码
        //不做无脑炫技人
        iSwing++;
        if(bIsPrimary)
            self.SendWeaponAnim( aryFireAnimation[iSwing % 2] );

        self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + flNextAttack;
        pPlayer.SetAnimation( PLAYER_ATTACK1 ); 
        g_SoundSystem.EmitSoundDyn( pPlayer.edict(), CHAN_WEAPON, aryFireSound[0], 1, ATTN_NORM, 0, 94 + Math.RandomLong( 0,0xF ) );
        

        if ( tr.flFraction >= 1.0 ){
            if( fFirst != 0 )
            if(!bIsPrimary)
                self.SendWeaponAnim(aryFireAnimation[3]);
        }
        else{
            fDidHit = true;
            CBaseEntity@ pEntity = g_EntityFuncs.Instance( tr.pHit );
            float flDamage = bIsPrimary ? 15 : 45;
            g_WeaponFuncs.ClearMultiDamage();
            if ( self.m_flNextPrimaryAttack + 1 < g_Engine.time )
                pEntity.TraceAttack( pPlayer.pev, flDamage, g_Engine.v_forward, tr, DMG_CLUB );  
            else
                pEntity.TraceAttack( pPlayer.pev, flDamage * 0.5, g_Engine.v_forward, tr, DMG_CLUB );      
            g_WeaponFuncs.ApplyMultiDamage( pPlayer.pev, pPlayer.pev );
            float flVol = 1.0;
            bool fHitWorld = true;

            if(!bIsPrimary)
                self.SendWeaponAnim(aryFireAnimation[2]);

            if( pEntity !is null ){
                if( pEntity.Classify() != CLASS_NONE && pEntity.Classify() != CLASS_MACHINE && pEntity.BloodColor() != DONT_BLEED ){
                    if( pEntity.IsPlayer() )
                        pEntity.pev.velocity = pEntity.pev.velocity + ( self.pev.origin - pEntity.pev.origin ).Normalize() * 120;
                    pPlayer.m_iWeaponVolume = 128; 
                    if( !pEntity.IsAlive() )
                        return true;
                    else
                        flVol = 0.1;
                    fHitWorld = false;
                }
            }

            if( fHitWorld ){
                float fvolbar = g_SoundSystem.PlayHitSound( tr, vecSrc, vecSrc + ( vecEnd - vecSrc ) * 2, BULLET_PLAYER_CROWBAR );
                fvolbar = 1;
            }

            pHitTrace = tr;
            SetThink( ThinkFunction( this.Smack ) );
            self.pev.nextthink = g_Engine.time + 0.2;
            pPlayer.m_iWeaponVolume = int( flVol * 512 ); 
        }
        return fDidHit;
    }
}