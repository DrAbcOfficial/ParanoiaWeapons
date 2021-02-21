class weapon_painkiller : CBaseParanoiaWeapon{
    weapon_painkiller(){
        szAnimation = "medkit";
        szSniperAnimation = "medkit";

        flDeploy = 2.4f;
     
        iDrawAnimation = 5;
       
        aryFireSound = {"itmes/medshot4.wav"};
    }

    bool Deploy(){
        return false;
	}

    void Precache() override{
		for(uint i = 0; i < aryFireSound.length(); i++){
            g_SoundSystem.PrecacheSound( aryFireSound[i] );
        }
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