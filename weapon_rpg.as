class weapon_paranoia_rpg : CBaseParanoiaWeapon{
    weapon_paranoia_rpg(){
        szVModel = "models/paranoia/v_rpg.mdl";
        szPModel = "models/paranoia/p_rpg.mdl";
        szWModel = "models/paranoia/w_rpg.mdl";
        szHUDModel = "sprites/paranoia/p_hud8.spr";

        szAnimation = "rpg";
        szSniperAnimation = "rpg";

        flDeploy = 2.4f;
        flShock = 0.0f;
        flReloadTime = 4.2f;
        flIronReloadTime = 4.2f;
        flPrimaryTime = 1.0f;
        flSccenaryTime = 0.33f;
        flIdleTime = 1.0f;
        flGrenadeSpeed = 3500;

        iDamage = 450;
        iDamage2 = 500;
        iDefaultGive = 2;
        iMaxAmmo1 = 5;
        iMaxClip = 1;
        iSlot = 7;
        iPosition = 6;
        iFlag = 0;
        iWeight = 10;
        iFOV = 95;
        iMoveSpeed = 250;

        bCanAutoFire = false;
        
        vecEjectOrigin = Vector(4, 21, -6);
        vecIronEjectOrigin = Vector(4, 21, -6);
        vecAccurency = VECTOR_CONE_4DEGREES;
        vecIronAccurency = VECTOR_CONE_3DEGREES;

        vec2XPunch = Vector2D(-24, 24);
        vec2YPunch = Vector2D(-4, 4);

        iDrawAnimation = 5;
        iReloadAnimation = 2;
        iIronReloadAnimation = 11;
        iChangeAnimation = 9;
        iReChangeAnimation = 10;

        aryFireAnimation = {3};
        aryIronFireAnimation = {3};
        aryIdleAnimation = {0, 1, 8};
        aryIronIdleAnimation = {6};

        aryFireSound = {"weapons/paranoia/rocketfire1.wav"};
        aryOtherSound = {"weapons/paranoia/rpg_reload.wav", "weapons/paranoia/rpg_reload2.wav"};
    }

    void Precache() override{
        g_Game.PrecacheOther("paranoia_rpg_rocket");
        g_Game.PrecacheModel( szWModel );
        g_Game.PrecacheGeneric( szWModel);
        g_Game.PrecacheModel( szVModel );
        g_Game.PrecacheGeneric( szVModel);
        g_Game.PrecacheModel( szPModel );
        g_Game.PrecacheGeneric( szPModel);

        g_Game.PrecacheModel( szHUDModel );
        g_Game.PrecacheGeneric( szHUDModel);

        for(uint i = 0; i < aryFireSound.length(); i++){
            g_SoundSystem.PrecacheSound( aryFireSound[i] );
            g_Game.PrecacheGeneric( "sound/" + aryFireSound[i]);
        }
        for(uint i = 0; i < aryOtherSound.length(); i++){
            g_SoundSystem.PrecacheSound( aryOtherSound[i] );
            g_Game.PrecacheGeneric( "sound/" + aryOtherSound[i]);
        }

        g_Game.PrecacheGeneric( "sprites/" + szSprDir + "/" + self.pev.classname + ".txt");
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

        //pPlayer.FireBullets(1, vecSrc, vecAiming, vecAcc, 8192, BULLET_PLAYER_CUSTOMDAMAGE, 2, iDamage + int(Math.RandomFloat(vecDamageDrift.x, vecDamageDrift.y)));

        paranoia_rpg_rocket@ pRPG7 = cast<paranoia_rpg_rocket@>(CastToScriptClass(g_EntityFuncs.CreateEntity( "paranoia_rpg_rocket", null,  false)));
        g_EntityFuncs.SetOrigin( pRPG7.self, pPlayer.GetGunPosition() );
        pRPG7.pev.velocity = g_Engine.v_forward * flGrenadeSpeed;
        @pRPG7.pev.owner = pPlayer.edict();
        pRPG7.pev.angles = Math.VecToAngles( pRPG7.pev.velocity );
        pRPG7.pev.dmg = iDamage;
        pRPG7.pev.frags = iDamage2;
        pRPG7.SetThink( ThinkFunction( pRPG7.Think ) );
        pRPG7.SetTouch( TouchFunction( pRPG7.Touch ) );
        g_EntityFuncs.DispatchSpawn( pRPG7.self.edict() );

        NetworkMessage m(MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null);
            m.WriteByte(TE_DLIGHT);
            m.WriteCoord(vecSrc.x);
            m.WriteCoord(vecSrc.y);
            m.WriteCoord(vecSrc.z);
            m.WriteByte(48);
            m.WriteByte(255);
            m.WriteByte(255);
            m.WriteByte(34);
            m.WriteByte(1);
            m.WriteByte(255);
        m.End();

        g_PlayerFuncs.ScreenShake(pPlayer.pev.origin, 16, 23, 3, 250);

        if( self.m_iClip == 0 && pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
            pPlayer.SetSuitUpdate( "!HEV_AMO0", false, 0 );
        
        pPlayer.pev.punchangle.x += Math.RandomFloat( vec2XPunch.x, vec2XPunch.y );
        pPlayer.pev.punchangle.y += Math.RandomFloat( vec2YPunch.x, vec2YPunch.y );
    }
    
    void SecondaryAttack() override{
        self.m_flTimeWeaponIdle = self.m_flNextSecondaryAttack = self.m_flNextPrimaryAttack = g_Engine.time + flSccenaryTime;
        //Nothing but sad panda
    }
}

class paranoia_rpg_rocket : ScriptBaseEntity {
    private string szMdl = "models/paranoia/rpgrocket.mdl";
    private string szSmoke = "sprites/spore_exp_b_01.spr";
    private string szSound = "weapons/paranoia/rocket1.wav";
    void Spawn() {
        Precache();
        self.pev.solid = SOLID_SLIDEBOX;
        self.pev.movetype = MOVETYPE_FLYMISSILE;
        self.pev.iuser2 = 1;
        g_EntityFuncs.SetModel( self, szMdl);
        g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_ITEM, szSound, 1.0, ATTN_NORM, 0, 95 + Math.RandomLong( 0, 10 ) );
        self.pev.nextthink = g_Engine.time + 0.07f;
    }

    void Precache(){
        g_Game.PrecacheModel(szMdl);
        g_Game.PrecacheModel(szSmoke);
        g_SoundSystem.PrecacheSound(szSound);
    }
    
    void Touch ( CBaseEntity@ pOther ) {
        if( g_EngineFuncs.PointContents( self.pev.origin ) == CONTENTS_SKY ){
            g_EntityFuncs.Remove( self );
            return;
        }
        self.pev.solid = SOLID_NOT;
        self.pev.movetype = MOVETYPE_NONE;
        self.pev.velocity = Vector( 0, 0, 0 );
        SetThink(null);
        TraceResult tr;
        tr = g_Utility.GetGlobalTrace();
        g_EntityFuncs.CreateExplosion(self.pev.origin, self.pev.angles, self.pev.owner, 200, false);
        g_WeaponFuncs.RadiusDamage( self.pev.origin,self.pev, self.pev.owner.vars, self.pev.dmg, self.pev.frags, CLASS_NONE, DMG_BLAST | DMG_ALWAYSGIB );
        g_Utility.DecalTrace( tr, DECAL_SCORCH1 + Math.RandomLong(0,1) );
        g_EntityFuncs.Remove( self ); 
    }
    
    void Think() {
        NetworkMessage m(MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null);
            m.WriteByte(TE_SPRITE);
            m.WriteCoord(self.pev.origin.x);
            m.WriteCoord(self.pev.origin.y);
            m.WriteCoord(self.pev.origin.z);
            m.WriteShort(g_EngineFuncs.ModelIndex(szSmoke));
            m.WriteByte(40);
            m.WriteByte(100);
        m.End();
        self.pev.nextthink = g_Engine.time + 0.07f;
    }
}