function [csi_segment_selected,subcarrier_index_list_per_antenna] = subcarrier_selection_var_filter(csi_data_source,n_antennas,n_subcarriers,subcarrier_selected,fc,deltaf)
% [FTP,F,V,T,CSI_CORR,CORR_T]=SPECTRUM_PROCESS(CSI_DATA,SAMPLE_RATE,MAX_FREQ,FFT_RATIO,CARRIER_FREQ,STATIC_CORR)
% calculates spectrogram of CSI data, as in Figure 4a, and correlation
% between subcarriers for motion detection, as in Section 5.1.
%
% DATA     : CSI series (N x 30 subcarriers)
% n_antennas: number of antenna
% n_subcarriers: number of subcarrie
% SAMPLE_RATE  : Sampling rate of CSI data.
% MAX_FREQ     : The upper bound frequency of spectrogram of interest.
% FFT_RATIO    : Time interval length for calculating FFT.
% CARRIER_FREQ : Carrier frequncy of CSI data.
% STATIC_CORR  : CSI correlation in static sceanrios. It is used for
%                subcarrier selection.
%
% csi_segment_selected          : Frequency time profile of CSI data.
% T            : Time axis.
% CSI_CORR     : CSI correlation for motion detection.
% CORR_T       : Timestamp of CSI correlation.

fc_delta=-n_subcarriers/2*deltaf:deltaf:n_subcarriers/2*deltaf;
fc_delta=[fc_delta(1,1:n_subcarriers/2),fc_delta(1,n_subcarriers/2+2:n_subcarriers+1)];
subcarrier_pre_selected=floor((subcarrier_selected+n_subcarriers)/2);

var_list=zeros(n_antennas,n_subcarriers);
subcarrier_index_list_per_antenna=zeros(n_antennas,subcarrier_selected);
csi_segment_selected=zeros(size(csi_data_source,1),n_antennas*subcarrier_selected);
for antenna_index = 1:n_antennas
    csi_data_antenna=csi_data_source(:,(antenna_index-1)*n_subcarriers+1:antenna_index*n_subcarriers);
    for subcarrier_index = 1:n_subcarriers
        var_list(antenna_index,subcarrier_index) = var(csi_data_antenna(:,subcarrier_index))*(fc_delta(subcarrier_index)+fc)/fc;
    end
%     [sA,index] = sort(abs(var_list(antenna_index,:)),'descend');
%     pre_index=sort(index(1:subcarrier_pre_selected));
    [sA,index] = sort((var_list(antenna_index,:)));
    subcarrier_index_list_per_antenna(antenna_index,:)=index(sort(index(1:subcarrier_selected)));
    %         corr_diff_sorted = sort(corr_diff, 'descend');
    %         csi_sel = corr_diff >= corr_diff_sorted(subcarrier_selected);
    csi_segment_selected(:,(antenna_index-1)*subcarrier_selected+1:antenna_index*subcarrier_selected)=csi_data_antenna(:,subcarrier_index_list_per_antenna(antenna_index,:));
end
end
