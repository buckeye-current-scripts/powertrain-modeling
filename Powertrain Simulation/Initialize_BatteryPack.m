%% Initialization file for selecting cell
%% Cell data files
if Cell_Selection == 1
    load Cell_Data\Ideal_600V;
elseif Cell_Selection == 2
    load Cell_Data\Efest_IMR18650_600V_42Ah_FirstOrder;
elseif Cell_Selection == 3
    load Cell_Data\LG_INR18650HG2_600V_42Ah_FirstOrder;
elseif Cell_Selection == 4
    load Cell_Data\LG_INR18650MJ1_600V_49Ah_FirstOrder;
elseif Cell_Selection == 5
    load Cell_Data\SanPan_NCR18650GA_600V_49Ah_FirstOrder;
end

V_cell_init = interp1(CELL.SOC,CELL.OCV,SOC_max);
P_lim_dch_init = interp1(CELL.SOC,CELL.Power_dch,SOC_max);
P_lim_ch_init = interp1(CELL.SOC,CELL.Power_ch,SOC_max);