*** |  (C) 2006-2023 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/45_carbonprice/exponential/datainput.gms
***----------------------------------------------------------------------------------------------------------------------------------------
*** CO2 tax level is calculated at an exponential increase with rate given by cm_co2_tax_growth from the 2020 tax level exogenously defined
*** regional prices can be initially differentiated by GDP/capita and converge using quadratic phase-in, 
*** global price from cm_CO2priceRegConvEndYr (default = 2050)
***----------------------------------------------------------------------------------------------------------------------------------------

parameters
p45_gdppcap2020_PPP(all_regi)               "2020 GDP per capita (k $ PPP 2005)"
p45_phasein_2025ratio(all_regi)             "ratio of CO2 price to that of developed region in 2025"

p45_regCO2priceFactor(ttot,all_regi)                    "regional multiplicative factor to the CO2 price of the developed countries"
p45_CO2priceTrajDeveloped(ttot)                         "CO2 price trajectory for developed/rich countries"
;


*** EOF ./modules/45_carbonprice/exponential/declarations.gms
