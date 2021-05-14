
clear;
clc;
close all;
%% Parameter Setting

% Set Parameters for Data Description
total_user=12;
total_gait = 1;
total_track = 7;
total_instance = 4;

% Set Parameters for Loading Data

%% Set Path for Saving Data
ground_truth_dir = [data_root,'GROUNDTRUTH/\20191124_preliminary/'];
if ~exist(ground_truth_dir)
    mkdir(ground_truth_dir);
end
foot_size=0;
%% classroom
%         ground_truth=[-0.9,3.6;-0.3,3.6;0.3,3.6;0.9,3.6;0.9,3;0.9,2.4;0.3,2.4;-0.3,2.4;-0.9,2.4;-0.9,1.8;-0.9,1.2;-0.3,1.2;0.3,1.2;0.9,1.2];
%         ground_truth=[-0.9,1.2;-0.9,1.8;-0.9,2.4;-0.9,3;-0.3,3;0.3,3;0.9,3;1.5,3];
%         ground_truth=[-1.5,1.2;-0.9,1.2;-0.3,1.2;0.3,1.2;0.9,1.2;0.9,1.8;0.9,2.4;0.3,2.4;-0.3,2.4;-0.9,2.4;-0.9,2.4;-0.3,2.4;0.3,2.4;0.9,2.4;0.9,3;0.9,3.6;0.3,3.6;-0.3,3.6;-0.9,3.6;-1.5,3.6];
%% office
% ground_truth_list=cell(total_track,1);
% ground_truth_list{1}=[0.6,1.2-foot_size;0.6,1.8;0.6,2.4-foot_size;];
% ground_truth_list{2}=[1-foot_size,1.2;0.6,1.2;0.2,1.2;-0.2,1.2;-0.6,1.2;-1+foot_size,1.2];
% ground_truth_list{3}=[-1+foot_size,1.2;-0.6,1.2;-0.2,1.2;0.2,1.2;0.2,1.8;0.2,2.4;0.2,3-foot_size];
% ground_truth_list{4}=[-0.6,1.8-foot_size;-0.6,1.2;-0.6,0.6;-0.2,0.6;0.2,0.6;0.6,0.6;0.6,1.2;0.6,1.8-foot_size];
% ground_truth_list{5}=[-0.2,1.2+foot_size;-0.2,1.8;-0.2,2.4;0.2,2.4;0.2,1.8;0.2,1.2;0.6,1.2;0.6,1.8;0.6,2.4-foot_size];
% ground_truth_list{6}=[0.6-0.5*foot_size,0.6+0.5*foot_size;0.2,1.2;-0.2,1.8;0.2,2.4;0.6,3];
%% corridor
% ground_truth_list=cell(total_track,1);
% ground_truth_list{1}=[1.8,1.2+foot_size;1.8,1.8;1.8,2.4;1.8,3;1.8,3.6;1.8,4.2-foot_size];
% ground_truth_list{2}=[-1.8,1.2+foot_size;-1.8,1.8;-1.8,2.4;-1.8,3;-1.8,3.6;-1.8,4.2-foot_size];
% ground_truth_list{3}=[1.8-foot_size,1.2;1.2,1.2;0.6,1.2;0,1.2;-0.6,1.2;-1.2,1.2;-1.8+foot_size,1.2;];
% ground_truth_list{4}=[1.8-foot_size,4.2;1.2,4.2;0.6,4.2;0,4.2;-0.6,4.2;-1.2,4.2;-1.8+foot_size,4.2;];
% ground_truth_list{5}=[1.8-foot_size,1.2;1.2,1.2;0.6,1.2;0,1.2;0,1.8;0,2.4;0,3;0,3.6;0,4.2-foot_size;];
% ground_truth_list{6}=[0.6,1.2+foot_size;0.6,1.8;0.6,2.4;0.6,3;0,3;-0.6,3;-0.6,2.4;-0.6,1.8;-0.6,1.2+foot_size;];
% ground_truth_list{7}=[1.2,1.2+foot_size;1.2,1.8;1.2,2.4;1.2,3;0.6,3;0,3;0,2.4;0,1.8;0,1.2;0,1.2;0,1.8;0,2.4;0,3;-0.6,3;-1.2,3;-1.2,2.4;-1.2,1.8;-1.2,1.2+foot_size;];
% ground_truth_list{8}=[-1.8+foot_size,1.2+foot_size/2;-1.2,1.8;-0.6,2.4;0,3;0,3;-0.6,2.4;-1.2,1.8;-1.8+foot_size/2,1.2+foot_size/2];
% ground_truth_list{9}=[1.8,1.8+foot_size;1.559,2.7;0.9,3.359;0,3.6-foot_size];
% ground_truth_list{10}=[1.2-foot_size,1.2;0.6,1.2;0,1.2;-0.6,1.2;-1.2,1.2;-0.6,1.8;-0,2.4;0.6,3;1.2,3.6;0.6,3.6;0,3.6;-0.6,3.6;-1.2+foot_size,3.6;];

ground_truth_list=cell(total_track,1);

ground_truth_list{1}=[1.8,1.2+foot_size;1.8,1.8;1.8,2.4;1.8,3;1.8,3.6;1.8,4.2-foot_size];
ground_truth_list{2}=[1.2,1.2+foot_size;1.2,1.8;1.2,2.4;1.2,3;1.2,3.6;1.2,4.2-foot_size];
ground_truth_list{3}=[0.6,1.2+foot_size;0.6,1.8;0.6,2.4;0.6,3;0.6,3.6;0.6,4.2-foot_size];
ground_truth_list{4}=[0,1.2+foot_size;0,1.8;0,2.4;0,3;0,3.6;0,4.2-foot_size];
ground_truth_list{5}=[-0.6,1.2+foot_size;-0.6,1.8;-0.6,2.4;-0.6,3;-0.6,3.6;-0.6,4.2-foot_size];
ground_truth_list{6}=[-1.2,1.2+foot_size;-1.2,1.8;-1.2,2.4;-1.2,3;-1.2,3.6;-1.2,4.2-foot_size];
ground_truth_list{7}=[-1.8,1.2+foot_size;-1.8,1.8;-1.8,2.4;-1.8,3;-1.8,3.6;-1.8,4.2-foot_size];

%% Signal Processing and Feature Extraction
for track_index = 1:total_track
    for instance_index = 1:total_instance
        ground_truth=ground_truth_list{track_index};
        if mod(instance_index,2)==0
            ground_truth=flipud(ground_truth);
        end
        groundtruth_path = [num2str(track_index),...
            '-', num2str(instance_index)];
        disp(['Loading ', groundtruth_path])
        save([ground_truth_dir,groundtruth_path, '.mat'],'ground_truth');
    end
%     scatter3(ground_truth(:,1),ground_truth(:,2),1:size(ground_truth,1));
%         hold on;
end
disp([ground_truth_dir,'is finished'])