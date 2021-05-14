function [csi_segment_selected,subcarrier_index_list_per_antenna] = subcarrier_selection_correlation_filter(csi_data_each_receiver_sequence,csi_data_source,n_antennas,n_subcarriers,subcarrier_selected,alpha,csi_subcarriers_index_selected)
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

subcarrier_index_list_per_antenna=zeros(n_antennas,subcarrier_selected);
csi_segment_selected=zeros(size(csi_data_source,1),n_antennas*subcarrier_selected);
corr_across_antennas=(corrcoef(csi_data_source));
corr_across_antennas_mean=mean(corr_across_antennas);
for antenna_index = 1:n_antennas
    csi_subcarriers_index_selected_per_antenna=csi_subcarriers_index_selected(antenna_index,:);
    antenna_sequence=(antenna_index-1)*n_subcarriers+1:antenna_index*n_subcarriers;
    corr_per_antenna=corr_across_antennas_mean(antenna_sequence)+alpha*mean(corr_across_antennas(antenna_sequence,antenna_sequence));
    [sA,index] = sort(corr_per_antenna,'descend');    
    subcarrier_index_list_per_antenna(antenna_index,:)=sort(csi_subcarriers_index_selected_per_antenna(index(1:subcarrier_selected)));
    csi_segment_selected(:,(antenna_index-1)*subcarrier_selected+1:antenna_index*subcarrier_selected)=csi_data_each_receiver_sequence(:,(antenna_index-1)*n_subcarriers+subcarrier_index_list_per_antenna(antenna_index,:));
end
end
