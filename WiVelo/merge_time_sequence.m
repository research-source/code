function [all_time_sequence,all_trail_sequence1,all_trail_sequence2,all_scaler] = merge_time_sequence(trail_sequence,time_sequence,time_matrix,sample_step)
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

% last_time1 = max(time_sequence{1});
% last_time2 = max(time_sequence{2});
% last_time = max(last_time1,last_time2);
% last_sample_index = ceil(last_time/(sample_step/1000));
% sample_time_sequence = 0:(sample_step/1000):ceil(last_time/(sample_step/1000));
% time_delay_sequence = sample_step-half_time_delay_window+time_delay_window_step*time_delay_offset:(sample_step/1000):ceil(last_time/(sample_step/1000));

all_time_sequence = [];
all_trail_sequence1 = [];
all_trail_sequence2 = [];
all_scaler = [];

h1 = 1;
h2 = 1;

while h1 <= length(time_sequence{1}(:)) && h2 <= length(time_sequence{2}(:))
    if time_sequence{1}(h1) == time_sequence{2}(h2)
        all_time_sequence = [all_time_sequence,time_sequence{1}(h1)];
        all_trail_sequence1 = [all_trail_sequence1,trail_sequence(h1,1)];
        all_trail_sequence2 = [all_trail_sequence2,trail_sequence(h2,2)];
        all_scaler = [all_scaler, sample_step/1000/(time_sequence{1}(h1)-time_matrix{1}(1,h1))];
        h1 = h1 + 1;
        h2 = h2 + 1;
    elseif time_sequence{1}(h1) < time_sequence{2}(h2)
        all_time_sequence = [all_time_sequence,time_sequence{1}(h1)];
        all_trail_sequence1 = [all_trail_sequence1,trail_sequence(h1,1)];
        all_scaler = [all_scaler, sample_step/1000/(time_sequence{1}(h1)-time_matrix{1}(1,h1))];
        if h2 == 1
            all_trail_sequence2 = [all_trail_sequence2,0];
        else
            all_trail_sequence2 = [all_trail_sequence2,all_trail_sequence2(end)];
        end
        h1 = h1 + 1;
    elseif time_sequence{1}(h1) > time_sequence{2}(h2)
        all_time_sequence = [all_time_sequence,time_sequence{2}(h2)];
        all_trail_sequence2 = [all_trail_sequence2,trail_sequence(h2,2)];
        all_scaler = [all_scaler, sample_step/1000/(time_sequence{2}(h2)-time_matrix{2}(1,h2))];
        if h1 == 1
            all_trail_sequence1 = [all_trail_sequence1,0];
        else
            all_trail_sequence1 = [all_trail_sequence1,all_trail_sequence1(end)];
        end
        h2 = h2 + 1;
    end
end

%                 if h1 <= length(time_sequence{1}(:))
%                     for iter = h1:length(time_sequence{1}(:))
%                         all_time_sequence = [all_time_seuqence,time_sequence{1}(h1)];
%                         all_trail_sequence1 = [all_trail_sequence1,trail_sequence(h1,1)]
%                         all_trail_sequence2 = [all_trail_sequence2,all_trail_sequence2(end)]
%                     end
%                 end
all_time_sequence = [0,all_time_sequence];
all_trail_sequence1 = [0, all_trail_sequence1];
all_trail_sequence2 = [0, all_trail_sequence2];
all_scaler = [0,all_scaler];
end
