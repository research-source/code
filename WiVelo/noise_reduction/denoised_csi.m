function [csi_data,time_sequence] = denoised_csi(csi_subcarriers_selected, n_receivers,virtual_antenna_step, sample_rate)
% Doppler Spectrum For Each Antenna

upper_order = 6;
upper_stop = 80;
lower_order = 3;
lower_stop = 1;

csi_data= cell(n_receivers,1);
time_sequence=cell(n_receivers,1);
for receiver_index = 1:n_receivers
    csi_data_one=csi_subcarriers_selected{receiver_index};
   
    %% Denoise
    %         csi_remove_los = bandpass_filter(csi_data_one,upper_order,lower_order, upper_stop, lower_stop, sample_rate / 2);
    samples_sequence=1:size(csi_data_one,1);
    time_sequence{receiver_index}=samples_sequence/sample_rate;
    
    csi_data_one=sgolayfilt(csi_data_one,5,virtual_antenna_step+1);
    csi_data{receiver_index}=csi_data_one;
end
end