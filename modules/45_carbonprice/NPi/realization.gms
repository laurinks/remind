*** |  (C) 2006-2024 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/45_carbonprice/NPi/realization.gms

@description This realization takes the carbon prices until 2020 from the input data
and implements as convergence scheme post 2020: parabolic convergence up to 25 US$2005/t CO2
in the convergence year (here chosen as 2100) and then constant

*####################### R SECTION START (PHASES) ##############################
$Ifi "%phase%" == "datainput" $include "./modules/45_carbonprice/NPi/datainput.gms"
*######################## R SECTION END (PHASES) ###############################
*** EOF ./modules/45_carbonprice/NPi/realization.gms
