class weapon_paranoia_glock : CBaseParanoiaWeapon{
    weapon_paranoia_glock(){
        szVModel = "models/paranoia/v_glock.mdl";
        szPModel = "models/paranoia/p_glock.mdl";
        szWModel = "models/paranoia/w_glock.mdl";
        szShellModel = "models/paranoia/glock_shell.mdl";
        szHUDModel = "sprites/paranoia/p_hud3.spr";

        szAnimation = "onehanded";
        szSniperAnimation = "onehanded";

        flDeploy = 1.1f;
        flShock = 0.0f;
        flReloadTime = 1.8f;
        flIronReloadTime = 1.8f;
        flPrimaryTime = 0.12f;
        flSccenaryTime = 0.33f;
        flIdleTime = 0.52f;

        iDamage = 14;
        iDefaultGive = 60;
        iMaxAmmo1 = 600;
        iMaxClip = 20;
        iSlot = 2;
        iPosition = 7;
        iFlag = 0;
        iWeight = 8;
        iFOV = 85;
        iMoveSpeed = 250;

        bCanAutoFire = false;
        
        vecEjectOrigin = Vector(4, 21, -6);
        vecIronEjectOrigin = Vector(4, 18, -4);
        vecAccurency = VECTOR_CONE_4DEGREES;
        vecIronAccurency = VECTOR_CONE_3DEGREES;

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

        aryFireSound = {"weapons/paranoia/glock_fire.wav"};
        aryOtherSound = {"weapons/paranoia/g_sliderelease1.wav", "weapons/paranoia/g_clipin1.wav", "weapons/paranoia/g_clipout1.wav", "weapons/paranoia/g_slideback1.wav"};
    }
}