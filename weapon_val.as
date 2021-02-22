class weapon_val : CBaseParanoiaWeapon{
    weapon_val(){
        szVModel = "models/paranoia/v_val.mdl";
        szPModel = "models/paranoia/p_val.mdl";
        szWModel = "models/paranoia/w_val.mdl";
        szShellModel = "models/paranoia/val_shell.mdl";
        szHUDModel = "sprites/paranoia/p_hud6.spr";

        szAnimation = "sniper";

        flDeploy = 1.8f;
        flShock = 0.3f;
        flReloadTime = 3.0f;
        flIronReloadTime = 3.0f;
        flPrimaryTime = 0.047f;
        flSccenaryTime = 0.31f;
        flIdleTime = 0.74f;

        iDamage = 28;
        iDefaultGive = 40;
        iMaxAmmo1 = 80;
        iMaxClip = 20;
        iSlot = 5;
        iPosition = 8;
        iFlag = 0;
        iWeight =  10;
        iFOV = 20;
        iMoveSpeed = 140;
        
        vecEjectOrigin = Vector(3, 18, -6);
        vecIronEjectOrigin = Vector(3, 18, -6);
        vecAccurency = VECTOR_CONE_6DEGREES;
        vecIronAccurency = g_vecZero;

        vec2XPunch = Vector2D(-1.4, 1.4);
        vec2YPunch = Vector2D(-1.5, 1.5);

        iDrawAnimation = 1;
        iReloadAnimation = 3;
        iIronReloadAnimation = 3;
        iChangeAnimation = 0;
        iReChangeAnimation = 0;

        aryFireAnimation = {2};
        aryIronFireAnimation = {2};
        aryIdleAnimation = {0};
        aryIronIdleAnimation = {0};

        aryFireSound = {"weapons/paranoia/val_fire1.wav", "weapons/paranoia/val_fire2.wav", "weapons/paranoia/val_fire3.wav"};
        aryOtherSound = {"weapons/paranoia/val_forearm.wav", "weapons/paranoia/val_01.wav", "weapons/paranoia/val_02.wav", "weapons/paranoia/val_out.wav", "weapons/paranoia/val_in.wav"};
    }

    void SecondaryAttack() override{
		g_PlayerFuncs.ScreenFade(pPlayer, g_vecZero, 0.3, 0, 255, FFADE_IN);
        if(!bIron)
            pPlayer.pev.viewmodel = "";
        else
            pPlayer.pev.viewmodel = szVModel;
        CBaseParanoiaWeapon::SecondaryAttack();
	}

    void Reload() override{
        if(bIron)
            SecondaryAttack();
        CBaseParanoiaWeapon::Reload();
    }
}