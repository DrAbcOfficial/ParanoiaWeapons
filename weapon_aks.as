class weapon_aks : CBaseParanoiaWeapon{
    weapon_aks(){
        szVModel = "models/paranoia/v_aks.mdl";
        szPModel = "models/paranoia/p_aks.mdl";
        szWModel = "models/paranoia/w_aks.mdl";
        szHUDModel = "sprites/paranoia/p_hud4.spr";
        szShellModel = "models/paranoia/aks_shell.mdl";

        szAnimation = "m16";

        flDeploy = 0.89f;
        flShock = 0.0f;
        flReloadTime = 3.2f;
        flIronReloadTime = 3.2f;
        flPrimaryTime = 0.08f;
        flSccenaryTime = 0.31f;
        flIdleTime = 1.0f;
        
        iDamage = 16;
        iDefaultGive = 90;
        iMaxAmmo1 = 120;
        iMaxClip = 30;
        iSlot = 3;
        iPosition = 22;
        iFlag = 0;
        iWeight = 8;
        iFOV = 70;
        iMoveSpeed = 200;
        iUnderWater = 1;
        
        vecEjectOrigin = Vector(6, 18, -6);
        vecIronEjectOrigin = Vector(6, 18, -6);
        vecAccurency = VECTOR_CONE_2DEGREES;
        vecIronAccurency = VECTOR_CONE_1DEGREES;

        vec2XPunch = Vector2D(-1, 1);
        vec2YPunch = Vector2D(-1, 1);

        iDrawAnimation = 2;
        iReloadAnimation = 1;
        iIronReloadAnimation = 8;
        iChangeAnimation = 5;
        iReChangeAnimation = 6;

        aryFireAnimation = {3};
        aryIronFireAnimation = {7};
        aryIdleAnimation = {0};
        aryIronIdleAnimation = {4};

        aryFireSound = {"weapons/paranoia/aks_fire1.wav", "weapons/paranoia/aks_fire2.wav", "weapons/paranoia/aks_fire3.wav"};
        aryOtherSound = {"weapons/paranoia/aks_out.wav", "weapons/paranoia/aks_in.wav", "weapons/paranoia/aks_01.wav", "weapons/paranoia/aks_02.wav"};
    }
}