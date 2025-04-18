*** |  (C) 2006-2024 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/02_welfare/utilitarian/bounds.gms

$IFTHEN.INCONV %cm_INCONV_PENALTY% == "on"
v02_inconvPenSolidsBuild.fx("2005",regi) = 0;
v02_inconvPen.fx("2005",regi) = 0;
$ENDIF.INCONV

*** EOF ./modules/02_welfare/utilitarian/bounds.gms
