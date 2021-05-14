
clear;
clc;
close all;
%% Set Parameters for Transceivers
wave_length = 299792458 / 5.825e9;
sample_rate=1000;
n_receivers = 2;     % Receiver count
n_antennas = 3;    % Antenna count for each receiver
n_subcarriers=30;

%% Set Parameters for Data Description
total_user=12;
total_track = 7;
total_instance = 4;

%% novoter setting
% half_n_virtual_antennas=48;
half_n_virtual_antennas=0;

%% Set Parameters for Signal Processing

virtual_antenna_step=32;
half_time_delay_window=50;
time_delay_window_step=50;
half_time_window=48;
subcarrier_step=5;
sample_step=128;
time_delay_offset=1;
time_delay_header=half_n_virtual_antennas+(time_delay_offset-1)*time_delay_window_step+1;

%% Set Parameters for Anchor Selection
search_range=5;
reward_weight=0.5;
compensation_factor=2.5;
ellipse_weight=0.5;

%% fine-tune parameter
det_threshold=0.1;
translation_scaling=2.5;

%% Antenna Setting
antenna_spacing=0.2;
antenna_mid_left=-2.4;
antenna_mid_right=2.4;
antenna_coords1 = [antenna_mid_left+antenna_spacing,0;antenna_mid_left,0;antenna_mid_left-antenna_spacing,0];
antenna_coords2 = [antenna_mid_right-antenna_spacing,0;antenna_mid_right,0;antenna_mid_right+antenna_spacing,0];
T = [0,0];

%% Set Parameters for Loading Data
data_type='20191124_preliminary';
csi_dir = [data_root,'CSI/',data_type,'/'];

%% Set Path for Loading Groundtruth

%% Set Path for Loading Feature
feature_dir = [data_root,'FEATURE/',data_type,'/'];
if ~exist(feature_dir)
    mkdir(feature_dir);
end

error_dir = [data_root,'ERROR/'];
if ~exist(error_dir)
    mkdir(error_dir);
end

error_path = [error_dir, data_type, 'ssd_widir.mat'];

if ~exist(error_path)
    error_matrix=cell(1,8,total_instance);
    %% Signal Processing and Feature Extraction
    user_index_in_order=1;
    for user_index=[3] %%1,8,12 (8,9,4)
        data_path=[csi_dir,user_dir{user_index}];
        track_index_in_order=1;
        for track_index = [1:3,14:18]
            for instance_index = 1:total_instance
                data_file_name = [num2str(user_index), '-', num2str(track_index),'-', num2str(instance_index)];
                
                feature_path = [feature_dir, data_file_name, 'ssd_widir.mat'];
                
                disp(["Loading ",feature_path])
                if ~exist(feature_path)
                    %% Signal pre-processing
                    tic;
                    csi_data= extract_csi_power([data_path, data_file_name],n_receivers, n_antennas, n_subcarriers);
                    [csi_data,time_sampling]= denoised_csi(csi_data,n_receivers, half_time_window,sample_rate);
                    %% voting for anchor sequence
                    [correlation_val,distribution_val,time_matrix] = correlation_profile(csi_data, time_sampling,n_receivers,n_antennas,n_subcarriers,subcarrier_step,sample_step,half_n_virtual_antennas, half_time_delay_window,virtual_antenna_step,time_delay_window_step,time_delay_offset,half_time_window);
                    [node_sequence,observing_phase_shift]= voting_hopping_sequence(correlation_val,distribution_val,n_receivers,det_threshold);
                    if (any([1:7]==track_index))
                        for ii =2:n_receivers
                            node_sequence_hopping=round(smoothdata(node_sequence{ii},'movmean',7));
                            node_sequence{ii}=node_sequence_hopping;
%                             figure((instance_index-1)*2+ii);
%                             scatter(1:size(node_sequence_hopping,1),node_sequence_hopping);
%                             set(gcf,'WindowStyle','normal','Position', [0,250*(mod(instance_index+2,3))+50,300,250]);
                        end
                    end
                    %% tracking virtual sequence
                    save(feature_path, 'node_sequence');
                else
                    load(feature_path);
                end
                
                %% error estimation
                error_matrix{user_index_in_order,track_index_in_order,instance_index}=node_sequence{2};
                %                     generate_demo_real_trail((track_index-1)*total_instance+instance_index,real_trail,ground_truth);
            end
            track_index_in_order=track_index_in_order+1;
        end
        user_index_in_order=user_index_in_order+1;
    end
    error_matrix=squeeze(error_matrix);
    save(error_path, 'error_matrix');
else
    load(error_path);
end
disp(["Loading ",error_path])
disp(['All finished'])