
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
total_track = 6;
total_instance = 4;

%% novoter setting
half_n_virtual_antennas=48;
% half_n_virtual_antennas=0;

%% Set Parameters for Signal Processing

virtual_antenna_step=32;
half_time_delay_window=40;
time_delay_window_step=5;
half_time_window=48;
subcarrier_step=4;
sample_step=128;
time_delay_offset=5;
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
data_type='20191210_corridor';
csi_dir = [data_root,'CSI/',data_type,'/'];

%% Set Path for Loading Groundtruth
groundtruth_dir = [data_root,'GROUNDTRUTH/',data_type,'/'];
if ~exist(groundtruth_dir)
    mkdir(groundtruth_dir);
end
%% Set Path for Loading Feature
feature_dir = [data_root,'FEATURE/',data_type,'/'];
if ~exist(feature_dir)
    mkdir(feature_dir);
end

error_dir = [data_root,'ERROR/'];
if ~exist(error_dir)
    mkdir(error_dir);
end

% error_path = [error_dir, data_type, '.mat'];
% error_path = [error_dir, data_type, 'novoter.mat'];
error_path = [error_dir, data_type, 'nomodel.mat'];

if exist(error_path)
    error_matrix=zeros(3,total_track,total_instance);
    %% Signal Processing and Feature Extraction
    user_index_in_order=1;
    for user_index=[1,8,12] %%1,8,12 (8,9,4)
        data_path=[csi_dir,user_dir{user_index}];
        for track_index = 6:total_track
            for instance_index = 1:total_instance
                data_file_name = [num2str(user_index), '-', num2str(track_index),'-', num2str(instance_index)];
                %% load ground truth
                groundtruth_path = [num2str(track_index),...
                    '-', num2str(instance_index)];
                disp(["Loading ",groundtruth_path])
                load([groundtruth_dir,groundtruth_path, '.mat']);
                
                %                 feature_path = [feature_dir, data_file_name, '.mat'];
                %                 feature_path = [feature_dir, data_file_name, 'novoter.mat'];
                feature_path = [feature_dir, data_file_name, 'nomodel.mat'];
                
                disp(["Loading ",feature_path])
                if ~exist(feature_path)
                    %% Signal pre-processing
                    tic;
                    csi_data= extract_csi_power([data_path, data_file_name],n_receivers, n_antennas, n_subcarriers);
                    [csi_data,time_sampling]= denoised_csi(csi_data,n_receivers, half_time_window,sample_rate);
                    %% voting for anchor sequence
                    [correlation_val,distribution_val,time_matrix] = correlation_profile(csi_data, time_sampling,n_receivers,n_antennas,n_subcarriers,subcarrier_step,sample_step,half_n_virtual_antennas, half_time_delay_window,virtual_antenna_step,time_delay_window_step,time_delay_offset,half_time_window);
                    [node_sequence,observing_phase_shift]= voting_hopping_sequence(correlation_val,distribution_val,n_receivers,det_threshold);
                    if (any([1,2]==track_index))
                        for ii =1:n_receivers
                            node_sequence{ii}=round(smoothdata(node_sequence{ii},'movmean',7));
                        end
                    end
                    %% tracking virtual sequence
                    real_trail = tracking_hopping_node(node_sequence);
                    real_trail=real_trail./max(abs(real_trail(:)))*compensation_factor+ground_truth(1,:);
                    save(feature_path, 'real_trail', 'observing_phase_shift','time_matrix');
                else
                    load(feature_path);
                end
                
                %                 feature_path = [feature_dir, data_file_name, '_trace','.mat'];
                %                 feature_path = [feature_dir, data_file_name, '_trace_novoter','.mat'];
                feature_path = [feature_dir, data_file_name, '_trace_nomodel','.mat'];
                
                disp(["Loading ",feature_path])
                if ~exist(feature_path)
                    n_sampling_for_trail=size(real_trail,1);
                    disp(data_file_name)
                    %% Translation
                    anchor_time_pick_sequence= anchor_selection(observing_phase_shift,time_matrix,search_range,reward_weight);
                    all_scaler=(anchor_time_pick_sequence*sample_rate-(time_delay_header+sample_step*(0:n_sampling_for_trail-1)'))/sample_step;
                    dir_sequence=(real_trail(2:n_sampling_for_trail,1:2)-real_trail(1:n_sampling_for_trail-1,1:2));
                    physical_dis=zeros(n_sampling_for_trail-1,1);
                    for hop_index = 2:n_sampling_for_trail
                        %% nomodel setting
                        %                         [~,physical_dis(hop_index)] = go_to_next(antenna_coords1, antenna_coords2, T, real_trail(hop_index-1,:), dir_sequence(hop_index-1,1), dir_sequence(hop_index-1,2));
                        %                         real_trail(hop_index,:)=real_trail(hop_index-1,:)+dir_sequence(hop_index-1,:)*(ellipse_weight*physical_dis(hop_index)./all_scaler(hop_index)+(1-ellipse_weight)*translation_scaling);
                        real_trail(hop_index,:)=real_trail(hop_index-1,:)+dir_sequence(hop_index-1,:)*translation_scaling;
                    end
                    save(feature_path, 'real_trail', 'ground_truth','anchor_time_pick_sequence');
                else
                    load(feature_path);
                end
                %% error estimation
                error_matrix(user_index_in_order,track_index,instance_index)=error_estimation(real_trail,ground_truth,anchor_time_pick_sequence,50,100)
                generate_demo_real_trail((track_index-1)*total_instance+instance_index,real_trail,ground_truth);
            end
        end
        user_index_in_order=user_index_in_order+1;
    end
%     save(error_path, 'error_matrix');
else
    load(error_path);
end
disp(["Loading ",error_path])
% cdfplot(error_matrix(:));
disp(['All finished'])