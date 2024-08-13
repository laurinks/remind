*** |  (C) 2006-2023 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/45_carbonprice/exo_diffCurvPhaseIn2Lin/datainput.gms
***----------------------------------------------------------------------------------------------------------------------------------------------------
*** regional prices are initially differentiated by GDP/capita and converge using quadratic phase-in, 
*** global price from cm_CO2priceRegConvEndYr (default = 2050)
*** carbon price of developed regions increases linearly until peak year (with iterative_target_adj = 9) or until 2100 (with iterative_target_adj = 5)
*** linear carbon price curve of developed regions starts at 0 in 2020 
***----------------------------------------------------------------------------------------------------------------------------------------------------


*** convergence to global CO2 price depends on GDP per capita (in 1e3 $ PPP 2005).
*** benchmark year kept at 2015 since 2020 not suitable. 
p45_gdppcap2015_PPP(regi) = pm_gdp("2015",regi)/pm_shPPPMER(regi) / pm_pop("2015",regi);
display p45_gdppcap2015_PPP;

*** Selection of differentiation scheme via cm_co2_tax_spread
if(cm_co2_tax_spread eq 1,
p45_phasein_2025ratio(regi) = 1; !! all regions
);

if(cm_co2_tax_spread eq 10,
p45_phasein_2025ratio(regi)$(p45_gdppcap2015_PPP(regi) le 3.5) = 0.1; !! SSA
p45_phasein_2025ratio(regi)$(p45_gdppcap2015_PPP(regi) gt 3.5 and p45_gdppcap2015_PPP(regi) le 5)  = 0.2; !! IND
p45_phasein_2025ratio(regi)$(p45_gdppcap2015_PPP(regi) gt 5   and p45_gdppcap2015_PPP(regi) le 10) = 0.3; !! OAS
p45_phasein_2025ratio(regi)$(p45_gdppcap2015_PPP(regi) gt 10  and p45_gdppcap2015_PPP(regi) le 15) = 0.5; !! CHA, REF, LAM
p45_phasein_2025ratio(regi)$(p45_gdppcap2015_PPP(regi) gt 15  and p45_gdppcap2015_PPP(regi) le 20) = 0.7; !! MEA, NEU
p45_phasein_2025ratio(regi)$(p45_gdppcap2015_PPP(regi) gt 20) = 1; !! EUR, JPN, USA, CAZ
);

if(cm_co2_tax_spread eq 20,
p45_phasein_2025ratio(regi)$(p45_gdppcap2015_PPP(regi) le 3.5) = 0.05; !! SSA
p45_phasein_2025ratio(regi)$(p45_gdppcap2015_PPP(regi) gt 3.5 and p45_gdppcap2015_PPP(regi) le 5)  = 0.1; !! IND
p45_phasein_2025ratio(regi)$(p45_gdppcap2015_PPP(regi) gt 5   and p45_gdppcap2015_PPP(regi) le 10) = 0.2; !! OAS
p45_phasein_2025ratio(regi)$(p45_gdppcap2015_PPP(regi) gt 10  and p45_gdppcap2015_PPP(regi) le 15) = 0.4; !! CHA, REF, LAM
p45_phasein_2025ratio(regi)$(p45_gdppcap2015_PPP(regi) gt 15  and p45_gdppcap2015_PPP(regi) le 20) = 0.6; !! MEA, NEU
p45_phasein_2025ratio(regi)$(p45_gdppcap2015_PPP(regi) gt 20) = 1; !! EUR, JPN, USA, CAZ
);
display p45_phasein_2025ratio;


*** for the current implementation, use the following trajectory for rich countries:
*** price increases linearly from 50 in 2030 until the pkBudgYr, then constant thereafer
if(cm_co2_tax_2020 lt 50,
  abort "please choose a valid cm_co2_tax_2020"
elseif cm_co2_tax_2020 ge 50,
*** convert tax value from $/t CO2eq to T$/GtC
  p45_CO2priceTrajDeveloped("2030") = 50 * sm_DptCO2_2_TDpGtC;
  p45_CO2priceTrajDeveloped("2040") = cm_co2_tax_2020 * sm_DptCO2_2_TDpGtC;  !! using cm_co2_tax_2020 to set CO2 price in 2040 (quick solution to avoid new switch)
);


*** Define curve through (2030, 50) and (2040, cm_co2_tax_2020)
p45_CO2priceTrajDeveloped(t)$(t.val ge 2030) = p45_CO2priceTrajDeveloped("2030") 
                                              + (p45_CO2priceTrajDeveloped("2040")-p45_CO2priceTrajDeveloped("2030"))/10 !! yearly increase
                                              * (t.val - 2030); 
*** Set CO2 price constant after peak
p45_CO2priceTrajDeveloped(t)$(t.val gt c_peakBudgYr) =sum(t2$(t2.val eq c_peakBudgYr),p45_CO2priceTrajDeveloped(t2)); 

*** Then create regional phase-in:
*** Set regional CO2 price factor equal to p45_phasein_2025ratio until 2025:
p45_regCO2priceFactor(t,regi)$(t.val le 2025) = p45_phasein_2025ratio(regi);
*** Then define quadratic phase-in until cm_CO2priceRegConvEndYr:
loop(t$((t.val gt 2025) and (t.val le cm_CO2priceRegConvEndYr)),
  p45_regCO2priceFactor(t,regi) = 
   min(1,
       max(0, 
	        p45_phasein_2025ratio(regi) + (1 - p45_phasein_2025ratio(regi)) * Power( (t.val - 2025) / (cm_CO2priceRegConvEndYr - 2025), 2) 
       )				 
   );
);
p45_regCO2priceFactor(t,regi)$(t.val ge cm_CO2priceRegConvEndYr) = 1;


*** transition to global price - starting point depends on GDP/cap
pm_taxCO2eq(t,regi) = p45_regCO2priceFactor(t,regi) * p45_CO2priceTrajDeveloped(t);


display p45_regCO2priceFactor, p45_CO2priceTrajDeveloped, pm_taxCO2eq;
*** EOF ./modules/45_carbonprice/exo_diffCurvPhaseIn2Lin/datainput.gms
