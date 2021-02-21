class weapon_aps : CBaseParanoiaWeapon{
    weapon_aps(){
        szVModel = "models/paranoia/v_aps.mdl";
        szPModel = "models/paranoia/p_aps.mdl";
        szWModel = "models/paranoia/w_aps.mdl";
        szShellModel = "models/paranoia/aps_shell.mdl";

        szAnimation = "onehanded";
        szSniperAnimation = "onehanded";

        flDeploy = 1.0f;
        flShock = 0.0f;
        flReloadTime = 1.9f;
        flIronReloadTime = 1.9f;
        flPrimaryTime = 0.32f;
        flSccenaryTime = 0.3f;
        flIdleTime = 0.73f;

        iDamage = 12;
        iDefaultGive = 40;
        iMaxAmmo1 = 90;
        iMaxClip = 10;
        iSlot = 2;
        iPosition = 6;
        iFlag = 0;
        iWeight = 4;
        iFOV = 85;
        iMoveSpeed = 250;

        bCanAutoFire = false;
        
        vecEjectOrigin = Vector(6, 18, -6);
        vecIronEjectOrigin = Vector(6, 18, -6);
        vecAccurency = VECTOR_CONE_2DEGREES;
        vecIronAccurency = VECTOR_CONE_1DEGREES;

        vec2XPunch = Vector2D(-2, 2);
        vec2YPunch = Vector2D(-4, 4);

        iDrawAnimation = 2;
        iReloadAnimation = 1;
        iIronReloadAnimation = 11;
        iChangeAnimation = 9;
        iReChangeAnimation = 10;

        aryFireAnimation = {3, 4, 5};
        aryIronFireAnimation = {7, 8};
        aryIdleAnimation = {0};
        aryIronIdleAnimation = {6};

        aryFireSound = {"weapons/paranoia/aps_fire.wav"};
        aryOtherSound = {"weapons/paranoia/aps_clipin.wav", "weapons/paranoia/aps_clipout.wav", "weapons/paranoia/aps_deploy.wav"};
    }
}