require(tidyverse)
require(quitte)

usemifs <- c(
    "/p/projects/piam/scenariomip/pilot_v2_hpc/remind/output/C_SMIPv02-L-SSP2-PkBudg1100-var01_NPi-rem-10/REMIND_generic_C_SMIPv02-L-SSP2-PkBudg1100-var01_NPi-rem-10.mif",
    "/p/projects/piam/scenariomip/pilot_v2_hpc/remind/output/C_SMIPv02-VL-SDP_MC-PkBudg750-def-rem-10/REMIND_generic_C_SMIPv02-VL-SDP_MC-PkBudg750-def-rem-10.mif"
)

inbigmif <- read.quitte(usemifs)

inbigmif %>% select(variable) %>% unique %>% write.csv2("varlist.csv",row.names=F)

inbigmif %>%
    filter(region %in% c(
        # "World","GLO"
        "REF"
    )) %>%
    filter(
        between(period,2020,2100)
    ) %>%
    filter(variable %in% c(
        # "Internal|Price|Biomass|Emulator presolve",
        # "Internal|Price|Biomass|Emulator presolve shifted",
        # "Internal|Price|Biomass|Emulator shifted",
        # "Internal|Price|Biomass|MAgPIE",
        # "Demand|Bioenergy|++|2nd generation",
         "Prices|Bioenergy",
         "Price|Carbon"
        # "Prices|GHG Emission|CO2|Primary Forest|Vegetation carbon",
        # "Emi|CO2|+|Land-Use Change",
        # "Emissions|CO2|Land|+|Land-use Change"
        # "Emissions|CO2|Land",
        # "Emissions|CO2|Land|Land-use Change|+|Deforestation",
        # "Emissions|CO2|Land|Land-use Change|+|Forest degradation",
        # "Emissions|CO2|Land|Land-use Change|+|Other land conversion"
        # "Emissions|CO2|Land|Land-use Change|+|Peatland",
        # "Emissions|CO2|Land|Land-use Change|+|Regrowth",
        # "Emissions|CO2|Land|Land-use Change|+|Residual",
        # "Emissions|CO2|Land|Land-use Change|+|SOM",
        # "Emissions|CO2|Land|Land-use Change|+|Timber"
        # "Resources|Land Cover Change|+|Cropland",
        # "Resources|Land Cover Change|+|Forest",
        # "Resources|Land Cover Change|+|Other Land",
        # "Resources|Land Cover Change|+|Pastures and Rangelands",
        # "Resources|Land Cover Change|+|Urban Area",
        # "Emissions|CO2|Land"
    )) %>%
    ggplot(aes(x=period, y = value, color = scenario)) +
    geom_line() +
    facet_wrap(~variable+unit+region+model,scales = "free")
