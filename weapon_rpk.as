class weapon_rpk : CBaseParanoiaWeapon{
    weapon_rpk(){
        szVModel = "models/paranoia/v_rpk.mdl";
        szPModel = "models/paranoia/p_rpk.mdl";
        szWModel = "models/paranoia/w_rpk.mdl";
        szShellModel = "models/paranoia/rpk_shell.mdl";
        szHUDModel = "sprites/paranoia/p_hud7.spr";

        szAnimation = "saw";

        flDeploy = 1.0f;
        flShock = 1.0f;
        flReloadTime = 4.5f;
        flIronReloadTime = 4.5f;
        flPrimaryTime = 0.1f;
        flSccenaryTime = 0.6f;
        flIdleTime = 1.0f;

        iDamage = 30;
        iDefaultGive = 300;
        iMaxAmmo1 = 450;
        iMaxClip = 150;
        iSlot = 6;
        iPosition = 22;
        iFlag = 0;
        iWeight = 4;
        iFOV = 70;
        iMoveSpeed = 140;
        
        vecEjectOrigin = Vector(6, 18, -6);
        vecIronEjectOrigin = Vector(6, 18, -6);
        vecAccurency = VECTOR_CONE_8DEGREES;
        vecIronAccurency = VECTOR_CONE_2DEGREES;

        vec2XPunch = Vector2D(-2, 2);
        vec2YPunch = Vector2D(-2, 2);

        iDrawAnimation = 8;
        iReloadAnimation = 6;
        iIronReloadAnimation = 7;
        iChangeAnimation = 1;
        iReChangeAnimation = 2;

        aryFireAnimation = {4};
        aryIronFireAnimation = {5};
        aryIdleAnimation = {3};
        aryIronIdleAnimation = {0};

        aryFireSound = {"weapons/paranoia/rpk_fire1.wav", "weapons/paranoia/rpk_fire2.wav", "weapons/paranoia/rpk_fire3.wav"};
        aryOtherSound = { "weapons/paranoia/pkm_coverup.wav", "weapons/paranoia/pkm_boxout.wav", "weapons/paranoia/pkm_chain.wav", "weapons/paranoia/pkm_boxin.wav", "weapons/paranoia/pkm_coverdown.wav"};
    }
}