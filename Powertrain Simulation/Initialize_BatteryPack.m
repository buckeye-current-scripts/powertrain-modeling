%% Initialization file for selecting cell
%% Cell data files
if Cell_Selection == 1
    load Cell_Data\Ideal_600V_100Ah;
elseif Cell_Selection == 2
    load Cell_Data\Efest_IMR18650_600V_49Ah;
elseif Cell_Selection == 3
    load Cell_Data\LG_INR18650HG2_600V_42Ah;
elseif Cell_Selection == 4
    load Cell_Data\LG_INR18650MJ1_600V_49Ah;
elseif Cell_Selection == 5
    load Cell_Data\SanPan_NCR18650GA_600V_49Ah;
end

V_cell_init = interp1(Cell.SOC_dch,Cell.OCV_dch,SOC_max);
P_lim_dch_init = interp1(Cell.SOC_dch,Cell.P_lim_dch,SOC_max);