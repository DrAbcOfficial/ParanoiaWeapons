const string szSprDir = "paranoia";

abstract class CBaseParanoiaWeapon: ScriptBasePlayerWeaponEntity{
    protected CBasePlayer@ pPlayer = null;

    protected string szVModel = "";
    protected string szPModel = "";
    protected string szWModel = "";
    protected string szShellModel = "";
    protected string szAnimation = "";
    protected string szSniperAnimation = "sniperscope";
    protected int iShell = 0;

    protected float flDeploy = 0.0f;
    protected float flShock = 0.0f;
    protected float flReloadTime = 0;
    protected float flIdleTime = 0;
    protected float flIronReloadTime = 0;
    protected float flPrimaryTime = 0;
    protected float flSccenaryTime = 1.0f;
    protected float flGrenadeSpeed = 800;

    protected int iDamage = 0;
    protected int iDamage2 = 0;
    protected int iDefaultGive = 0;
    protected int iMaxAmmo1 = 0;
    protected int iMaxAmmo2 = -1;
    protected int iMaxClip = 0;
    protected int iSlot = 0;
    protected int iPosition = 0;
    protected int iFlag = 0;
    protected int iWeight = 0;
    protected int iFOV = 0;
    protected int iMoveSpeed = 0;
    protected TE_BOUNCE iShellSound = TE_BOUNCE_SHELL;

    protected bool bCanAutoFire = true;
    protected int iUnderWater = 0;

    protected Vector vecEjectOrigin = Vector(18, 8, -6);
    protected Vector vecIronEjectOrigin = Vector(18, 8, -6);
    protected Vector vecAccurency = g_vecZero;
    protected Vector vecIronAccurency = g_vecZero;
    protected Vector vecOffeset = g_vecZero;

    protected Vector2D vec2XPunch = Vector2D(0, 0);
    protected Vector2D vec2YPunch = Vector2D(0, 0);
    protected Vector2D vecDamageDrift = Vector2D(-1, 1);

    protected int iDrawAnimation = 0;
    protected int iReloadAnimation = 0;
    protected int iIronReloadAnimation = 0;
    protected int iChangeAnimation = 0;
    protected int iReChangeAnimation = 0;

    protected array<int>@ aryFireAnimation = {};
    protected array<int>@ aryIronFireAnimation = {};
    protected array<int>@ aryIdleAnimation = {};
    protected array<int>@ aryIronIdleAnimation = {};

    protected string szEmptySound = "hl/weapons/357_cock1.wav";
    protected array<string>@ aryFireSound = {};
    protected array<string>@ aryOtherSound = {};

    protected bool bIron = false;

    protected bool bAutoFlag = false;

    void Spawn(){
		Precache();
		g_EntityFuncs.SetModel(self, szWModel);
		self.m_iDefaultAmmo = iDefaultGive;
		self.FallInit();
	}

    void Precache(){
		g_Game.PrecacheModel( szWModel );
		g_Game.PrecacheModel( szVModel );
		g_Game.PrecacheModel( szPModel );

        if(!szShellModel.IsEmpty())
		    iShell = g_Game.PrecacheModel( szShellModel );

        g_SoundSystem.PrecacheSound( szEmptySound );
		for(uint i = 0; i < aryFireSound.length(); i++){
            g_SoundSystem.PrecacheSound( aryFireSound[i] );
        }
        for(uint i = 0; i < aryOtherSound.length(); i++){
            g_SoundSystem.PrecacheSound( aryOtherSound[i] );
        }

        g_Game.PrecacheGeneric( "sprites/" + szSprDir + "/" + self.pev.classname + ".txt");
	}

    bool GetItemInfo( ItemInfo& out info ){
		info.iMaxAmmo1	= iMaxAmmo1;
		info.iMaxAmmo2	= iMaxAmmo2;
		info.iMaxClip	= iMaxClip;
		info.iSlot		= iSlot;
		info.iPosition	= iPosition;
		info.iFlags		= iFlag;
		info.iWeight	= iWeight;
		return true;
	}

    bool AddToPlayer( CBasePlayer@ pPlayer ){
		if( BaseClass.AddToPlayer (pPlayer)){
			@this.pPlayer = pPlayer;
			NetworkMessage m( MSG_ONE, NetworkMessages::WeapPickup, pPlayer.edict() );
				m.WriteLong( g_ItemRegistry.GetIdForName(self.pev.classname) );
			m.End();
			return true;
		}
		return false;
	}

    bool PlayEmptySound(){
		if( self.m_bPlayEmptySound ){
			self.m_bPlayEmptySound = false;
			g_SoundSystem.EmitSoundDyn( pPlayer.edict(), CHAN_AUTO, szEmptySound, 0.9, ATTN_NORM, 0, PITCH_NORM );
		}
		return false;
	}

    void Holster( int skipLocal = 0 ) {
		self.m_fInReload = false;
		bIron = false;
		pPlayer.SetMaxSpeedOverride(-1);
		SetThink( null );
		ToggleZoom( 0 );
		BaseClass.Holster( skipLocal );
	}

    void SetFOV( int fov ){
		pPlayer.pev.fov = pPlayer.m_iFOV = fov;
	}

    void ToggleZoom( int zoomedFOV ){
		if (self.m_fInZoom)
			SetFOV(0);
		else
			SetFOV( zoomedFOV );
	}

    bool Deploy(){
		bool bResult = self.DefaultDeploy ( self.GetV_Model( szVModel ), self.GetP_Model( szPModel ), iDrawAnimation, szAnimation );
		self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + flDeploy;
		return bResult;
	}

    void PrimaryAttack(){
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

		pPlayer.FireBullets(1, vecSrc, vecAiming, vecAcc, 8192, BULLET_PLAYER_CUSTOMDAMAGE, 2, iDamage + int(Math.RandomFloat(vecDamageDrift.x, vecDamageDrift.y)));

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

        Vector vecShellOffset = bIron ? vecIronEjectOrigin : vecEjectOrigin;
        Vector vecShellOrigin = g_Engine.v_right * vecShellOffset.x + g_Engine.v_forward * vecShellOffset.y + g_Engine.v_up * vecShellOffset.z;

        g_EntityFuncs.EjectBrass( 
            pPlayer.GetGunPosition() + vecShellOrigin, 
            g_Engine.v_right * Math.RandomLong(80,160) + g_Engine.v_forward * Math.RandomLong(-20,80) + pPlayer.pev.velocity, 
            pPlayer.pev.angles[1], 
            iShell, 
            iShellSound );
	}
    
    void SecondaryAttack(){
		self.m_flTimeWeaponIdle = self.m_flNextSecondaryAttack = self.m_flNextPrimaryAttack = g_Engine.time + flSccenaryTime;
        if(bIron){
            self.SendWeaponAnim(iReChangeAnimation, 0, 0);
            pPlayer.SetMaxSpeedOverride(-1);
			ToggleZoom( 0 );
			pPlayer.m_szAnimExtension = szAnimation;
        }
        else{
            self.SendWeaponAnim(iChangeAnimation, 0, 0);
            pPlayer.SetMaxSpeedOverride(iMoveSpeed);
			ToggleZoom( iFOV );
			pPlayer.m_szAnimExtension = szSniperAnimation;
        }
        bIron = !bIron;
	}

    void FinishReload(){
        if(bIron){
			ToggleZoom( iFOV );
			pPlayer.m_szAnimExtension = szSniperAnimation;
        }
        BaseClass.FinishReload();
    }

    void Reload(){
		if( self.m_iClip >= iMaxClip || pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0)
			return;

        if(bIron){
			ToggleZoom( 0 );
			pPlayer.m_szAnimExtension = szAnimation;
        }
        pPlayer.SetAnimation(PLAYER_RELOAD);
		self.DefaultReload( iMaxClip, bIron ? iIronReloadAnimation : iReloadAnimation,  bIron ? flIronReloadTime : flReloadTime, 0 );
	}

    void WeaponIdle(){
		self.ResetEmptySound();
        if(bAutoFlag)
            bAutoFlag = false;
		if( self.m_flTimeWeaponIdle > g_Engine.time )
			return;
        array<int>@ aryAnimation = bIron ? aryIronIdleAnimation : aryIdleAnimation;
		self.SendWeaponAnim(aryAnimation[Math.RandomLong(0, aryAnimation.length() - 1)]);
		self.m_flTimeWeaponIdle = g_Engine.time + Math.RandomFloat( 10, 15 );
	}
}

void ParanoiaWeaponRegister(string szClassName, string szWeaponName, string szAmmoName, string szAmmoClass = "", string szAmmo2Name = "")
{
	g_CustomEntityFuncs.RegisterCustomEntity( szClassName, szWeaponName );
	g_ItemRegistry.RegisterWeapon( szWeaponName, szSprDir, szAmmoName, szAmmo2Name, szAmmoClass);
    g_Game.PrecacheOther(szWeaponName);
}