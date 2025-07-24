//spawn Hill_fnc_assignCurator with the right parameters determined by the player joining
 _unitName = str (_this select 0);

switch (_unitName) do {
    case "blu_co":       { [blu_co,       zeus_co]        spawn Hill_fnc_assignCurator };
    case "blu_cs":       { [blu_cs,       zeus_cs]        spawn Hill_fnc_assignCurator };
    case "blu_snco":     { [blu_snco,     zeus_snco]      spawn Hill_fnc_assignCurator };
    case "ltc":          { [ltc,          zeus_ltc]       spawn Hill_fnc_assignCurator };
    case "maj":          { [maj,          zeus_maj]       spawn Hill_fnc_assignCurator };
    case "msgt":         { [msgt,         zeus_msgt]      spawn Hill_fnc_assignCurator };
    case "blu_plt1_pl":  { [blu_plt1_pl,  zeus_plt1_pl]   spawn Hill_fnc_assignCurator };
    case "blu_plt1_ps1": { [blu_plt1_ps1, zeus_plt1_ps1]  spawn Hill_fnc_assignCurator };
    case "blu_plt1_ps2": { [blu_plt1_ps2, zeus_plt1_ps2]  spawn Hill_fnc_assignCurator };
    case "blu_plt2_pl":  { [blu_plt2_pl,  zeus_plt2_pl]   spawn Hill_fnc_assignCurator };
    case "blu_plt2_ps":  { [blu_plt2_ps,  zeus_plt2_ps]   spawn Hill_fnc_assignCurator };
    case "red_plt":      { [red_plt,      zeus_red_plt]   spawn Hill_fnc_assignCurator };
    case "red_1_plt":    { [red_1_plt,    zeus_red_1_plt] spawn Hill_fnc_assignCurator };
    case "grn_plt":      { [grn_plt,      zeus_grn_plt]   spawn Hill_fnc_assignCurator };
    case "grn_1_plt":    { [grn_1_plt,    zeus_grn_1_plt] spawn Hill_fnc_assignCurator };
};

