class weapon_ak74 : CBaseParanoiaWeapon{
    weapon_ak74(){
        szVModel = "models/paranoia/v_ak74.mdl";
        szPModel = "models/paranoia/p_ak74.mdl";
        szWModel = "models/paranoia/w_ak74.mdl";
        szHUDModel = "sprites/paranoia/p_hud4.spr";
        szShellModel = "models/paranoia/ak74_shell.mdl";

        szAnimation = "mp5";

        flDeploy = 0.89f;
        flShock = 0.0f;
        flReloadTime = 3.2f;
        flIronReloadTime = 3.2f;
        flPrimaryTime = 0.12f;
        flSccenaryTime = 0.31f;
        flIdleTime = 1.0f;

        iDamage = 20;
        iDefaultGive = 90;
        iMaxAmmo1 = 120;
        iMaxClip = 30;
        iSlot = 3;
        iPosition = 21;
        iFlag = 0;
        iWeight = 4;
        iFOV = 70;
        iMoveSpeed = 200;
        iUnderWater = 1;
        
        vecEjectOrigin = Vector(6, 18, -6);
        vecIronEjectOrigin = Vector(6, 18, -6);
        vecAccurency = VECTOR_CONE_4DEGREES;
        vecIronAccurency = VECTOR_CONE_2DEGREES;

        vec2XPunch = Vector2D(-2, 2);
        vec2YPunch = Vector2D(-2, 2);

        iDrawAnimation = 2;
        iReloadAnimation = 1;
        iIronReloadAnimation = 8;
        iChangeAnimation = 5;
        iReChangeAnimation = 6;

        aryFireAnimation = {3};
        aryIronFireAnimation = {7};
        aryIdleAnimation = {0};
        aryIronIdleAnimation = {4};

        aryFireSound = {"weapons/paranoia/ak74_fire1.wav", "weapons/paranoia/ak74_fire2.wav"};
        aryOtherSound = {"weapons/paranoia/aks_out.wav", "weapons/paranoia/aks_in.wav", "weapons/paranoia/aks_01.wav", "weapons/paranoia/aks_02.wav"};
    }
}