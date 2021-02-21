class weapon_groza : CBaseParanoiaWeapon{
    weapon_groza(){
        szVModel = "models/paranoia/v_groza.mdl";
        szPModel = "models/paranoia/p_groza.mdl";
        szWModel = "models/paranoia/w_groza.mdl";
        szShellModel = "models/paranoia/groza_shell.mdl";

        szAnimation = "sniper";

        flDeploy = 1.7f;
        flShock = 0.0f;
        flReloadTime = 2.8f;
        flIronReloadTime = 2.8f;
        flPrimaryTime = 0.11f;
        flSccenaryTime = 0.31f;
        flIdleTime = 0.86f;

        iDamage = 25;
        iDefaultGive = 60;
        iMaxAmmo1 = 80;
        iMaxClip = 20;
        iSlot = 5;
        iPosition = 21;
        iFlag = 0;
        iWeight = 8;
        iFOV = 40;
        iMoveSpeed = 150;
        
        vecEjectOrigin = Vector(3, 15, -6);
        vecIronEjectOrigin = Vector(3, 10, -6);
        vecAccurency = VECTOR_CONE_4DEGREES;
        vecIronAccurency = VECTOR_CONE_2DEGREES;

        vec2XPunch = Vector2D(-2, 2);
        vec2YPunch = Vector2D(-2, 2);

        iDrawAnimation = 1;
        iReloadAnimation = 3;
        iIronReloadAnimation = 3;
        iChangeAnimation = 0;
        iReChangeAnimation = 0;

        aryFireAnimation = {2};
        aryIronFireAnimation = {2};
        aryIdleAnimation = {0};
        aryIronIdleAnimation = {0};

        aryFireSound = {"weapons/paranoia/groza_fire1.wav", "weapons/paranoia/groza_fire2.wav", "weapons/paranoia/groza_fire3.wav"};
        aryOtherSound = {"weapons/paranoia/aks_01.wav", "weapons/paranoia/aks_out.wav", "weapons/paranoia/aks_in.wav"};
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