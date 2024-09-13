*** |  (C) 2006-2023 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/45_carbonprice/exponential/datainput.gms
***----------------------------
*** CO2 Tax level
***----------------------------

Execute_Loadpoint "input_ref" pm_taxCO2eq = pm_taxCO2eq;

pm_taxCO2eq(t,regi) = sum(ttot, pm_taxCO2eq(ttot,regi)$(ttot.val eq cm_startyear - 5)) * cm_co2_tax_growth**(t.val-cm_startyear+5);
pm_taxCO2eq(t,regi)$(t.val gt 2110) = pm_taxCO2eq("2110",regi); !! to prevent huge taxes after 2110 and the resulting convergence problems, set taxes after 2110 equal to 2110 value


*** EOF ./modules/45_carbonprice/exponential/datainput.gms
