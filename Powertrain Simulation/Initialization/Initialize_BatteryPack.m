%% Initialization file for selecting cell
%% Cell data files
if Cell_Selection == 1
    load Cell_Data\Ideal_400V_ZerothOrder;
elseif Cell_Selection == 2
    load Cell_Data\Ideal_600V_ZerothOrder;
elseif Cell_Selection == 3
    load Cell_Data\Ideal_700V_ZerothOrder;
elseif Cell_Selection == 3
%     load Cell_Data\Efest_IMR18650_600V_42Ah_ZerothOrder;
%     load Cell_Data\Efest_IMR18650_600V_42Ah_FirstOrder;
    load Cell_Data\Efest_IMR18650_600V_45Ah_ZerothOrder;
elseif Cell_Selection == 4
%     load Cell_Data\LG_INR18650HG2_600V_42Ah_ZerothOrder;
%     load Cell_Data\LG_INR18650HG2_600V_42Ah_FirstOrder;
    load Cell_Data\LG_INR18650HG2_600V_45Ah_ZerothOrder;
elseif Cell_Selection == 5
%     load Cell_Data\LG_INR18650MJ1_600V_49Ah_ZerothOrder;
%     load Cell_Data\LG_INR18650MJ1_600V_49Ah_FirstOrder;
    load Cell_Data\LG_INR18650MJ1_600V_52Ah_ZerothOrder;
elseif Cell_Selection == 6
%     load Cell_Data\SanPan_NCR18650GA_600V_49Ah_ZerothOrder;
%     load Cell_Data\SanPan_NCR18650GA_600V_49Ah_FirstOrder;
    load Cell_Data\SanPan_NCR18650GA_600V_52Ah_ZerothOrder;
end

V_cell_init = interp1(CELL.SOC,CELL.OCV,SOC_max);
P_lim_dch_init = interp1(CELL.SOC,CELL.Power_dch,SOC_max);
P_lim_ch_init = interp1(CELL.SOC,CELL.Power_ch,SOC_max);