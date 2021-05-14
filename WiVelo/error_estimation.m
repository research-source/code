function error = error_estimation(trail_estimated,ground_truth,anchor_time_pick_sequence,sample_rate,dtw_window)
% CORR_VAL=STATIC_CORRELATION(CSI_DATA, N_DEVICES, N_ANTENNAS,
% N_SUBCARRIERS, SAMPLE_RATE, MAX_FREQ, MIN_FREQ, START_TIME, DURATION)
% calculates the correlation of CSI subcarriers in static scenarios.
%
% CSI_DATA      : Raw CSI measurements, eg:dim($(time_series),n_antennas*n_subcarriers)
% N_ANTENNAS    : Number of antennas per devices
% N_SUBCARRIERS : Number of subcarriers in CSI
% SAMPLE_RATE   : Target sampling rate of interpolation
% START_TIME    : Start time for calculating correlation of CSI.
% DURATION      : Duration of data used for correlation.
%
% CORR_VAL      : Average correlation value per subcarrier, antenna
%

% Calculate correlation coefficient.
x1=sgolayfilt(trail_estimated(:,1),3,11);

y1=sgolayfilt(trail_estimated(:,2),3,11);

final_tick=anchor_time_pick_sequence(end);
t= 0:1/sample_rate:final_tick;
t_truth= 1/sample_rate:final_tick/length(ground_truth):final_tick;

xq1 = interp1(anchor_time_pick_sequence,x1,t,'linear','extrap');
yq1 = interp1(anchor_time_pick_sequence,y1,t,'linear','extrap');

xq1_truth = interp1(t_truth,ground_truth(:,1),t,'linear','extrap');
yq1_truth = interp1(t_truth,ground_truth(:,2),t,'linear','extrap');

pos_esi=[xq1;yq1]';
pos_truth=[xq1_truth;yq1_truth]';
error=dtw_c(pos_esi,pos_truth,dtw_window)/length(t);

end
