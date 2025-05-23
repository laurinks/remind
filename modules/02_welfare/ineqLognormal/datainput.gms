*** |  (C) 2006-2024 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/02_welfare/ineqLognormal/datainput.gms

pm_welf(ttot)$(ttot.val ge 2005) = 1;
$if %cm_less_TS% == "on"  pm_welf("2060") = 0.9;

*RP* 2012-03-06: Inconvenience costs on seprod
$IFTHEN.INCONV %cm_INCONV_PENALTY% == "on"
p02_inconvpen_lap(ttot,regi,"coaltr")$(ttot.val ge 2005)      = sm_D2005_2_D2017 * 0.5;    !! In dollar per GJ seprod at 1.000$/cap GDP, or 10$/GJ at 10.000$_GDP/cap
p02_inconvpen_lap(ttot,regi,"coaltr")$( (ttot.val ge 2005) AND (ttot.val le 2025) ) = 0.33 * p02_inconvpen_lap("2050",regi,"coaltr");  !! phase-in to decrease jump from historic 2020 fesob|foss to model 2025 results
p02_inconvpen_lap("2030",regi,"coaltr") = 0.66 * p02_inconvpen_lap("2050",regi,"coaltr");  !! phase-in to decrease jump from historic 2020 fesob|foss to model 2025 results

p02_inconvpen_lap(ttot,regi,"biotr")$(ttot.val ge 2005)       = sm_D2005_2_D2017 * 1.0;   
p02_inconvpen_lap(ttot,regi,"biotrmod")$(ttot.val ge 2005)    = sm_D2005_2_D2017 * 0;    !! for the moment, set InconvPen for fesos to ezero to make calibrations more stable
*' Transformation of coal to liquids/gases/H2 brings local pollution, which is less accepted at higher incomes -> use the inconvenience cost channel
p02_inconvpen_lap(ttot,regi,"coalftrec")$(ttot.val ge 2005)   = sm_D2005_2_D2017 * 0.9;    
p02_inconvpen_lap(ttot,regi,"coalftcrec")$(ttot.val ge 2005)  = sm_D2005_2_D2017 * 0.9;
p02_inconvpen_lap(ttot,regi,"coalgas")$(ttot.val ge 2005)     = sm_D2005_2_D2017 * 0.9;
p02_inconvpen_lap(ttot,regi,"coalh2")$(ttot.val ge 2005)      = sm_D2005_2_D2017 * 0.9;
p02_inconvpen_lap(ttot,regi,"coalh2c")$(ttot.val ge 2005)     = sm_D2005_2_D2017 * 0.9;
p02_inconvpen_lap(ttot,regi,te)$(ttot.val ge 2005) = p02_inconvpen_lap(ttot,regi,te) * 4.3 * 1E-4;            !! convert such that a value of 1 is equivalent to 1$/GJ at 1000$/per Capita in the welfare logarithm
p02_inconvpen_lap(ttot,regi,te)$(ttot.val ge 2005) = p02_inconvpen_lap(ttot,regi,te) * (1/sm_giga_2_non) / sm_GJ_2_TWa; !! conversion util/(GJ/cap) -> util/(TWa/Gcap)
*RP* these values are all calculated on seprod level.
display p02_inconvpen_lap;
$ENDIF.INCONV

*BS* 2020-03-12: additional inputs for inequality
*** To Do: rename file, then also in "files" and mrremind::fullREMIND.R
parameter f02_ineqTheil(tall,all_regi,all_GDPpopScen)        "Gini data"
/
$ondelim
$include "./modules/02_welfare/ineqLognormal/input/f_ineqTheil.cs4r"
$offdelim
/
;
p02_ineqTheil(ttot,regi)$(ttot.val ge 2005) = f02_ineqTheil(ttot,regi,"%cm_GDPpopScen%");
display p02_ineqTheil;


*** for a policy run, we need to load values coming from the baseline for consumption, tax revenues and energy expenditures:
if ((cm_emiscen ne 1),
    Execute_Loadpoint 'input_ref' p02_taxrev_redistr0_ref=v02_taxrev_Add.l;
    Execute_Loadpoint 'input_ref' p02_cons_ref=vm_cons.l;
    Execute_Loadpoint 'input_ref' p02_energyExp_ref=v02_energyExp.l;
    Execute_Loadpoint 'input_ref' p02_damageFactor_ref=vm_damageFactor.l;
);

*** income elasticity of tax revenues redistribution.
p02_distrBeta(ttot,regi)$(ttot.val ge 2005) = cm_distrBeta;


*** for a baseline we need the following variables to be 0:
p02_energyExp_ref(ttot,regi)$(cm_emiscen eq 1)=0;
p02_taxrev_redistr0_ref(ttot,regi)$(cm_emiscen eq 1)=0;
v02_taxrev_Add.l(ttot,regi)$(cm_emiscen eq 1)=0;
v02_energyExp_Add.l(ttot,regi)$(cm_emiscen eq 1)=0;
v02_energyexpShare.l(ttot,regi)$(cm_emiscen eq 1)=0;
v02_revShare.l(ttot,regi)$(cm_emiscen eq 1)=0;

*** For runs that are not baseline, we need to initialize:
*** taxrev_Add, because they are used in the condition sign:
v02_taxrev_Add.l(ttot,regi)$(cm_emiscen ne 1)=0;
*** and v02_energyExp to the level in the baseline so the model can have a start value
v02_energyExp.l(ttot,regi)$(cm_emiscen eq 1)=p02_energyExp_ref(ttot,regi)$(cm_emiscen eq 1);

*** parameters for translating output damage into consumption loss
parameter f02_damConsFactor(all_regi,dam_factors)    "for translating output to consumption losses from KW damage function"
/
$ondelim
$include "./modules/02_welfare/ineqLognormal/input/damage2consumption_loss_coefs_noscen.inc"
$offdelim
/
;

p02_damConsFactor1(ttot,regi)=f02_damConsFactor(regi,"f1");
p02_damConsFactor2(ttot,regi)=f02_damConsFactor(regi,"f2");

*** EOF ./modules/02_welfare/ineqLognormal/datainput.gms
