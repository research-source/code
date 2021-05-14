function [csi_data] = extract_csi_power(data_file, n_receivers, n_antennas,n_subcarriers)
csi_data= cell(n_receivers,1);
for receiver_index = 1:n_receivers
    spth = [data_file, '-r', num2str(receiver_index), '.dat'];
    try
        tic;
        [csi_data_one, timestamp] = generate_csi_from_dat(spth,n_antennas,n_subcarriers);
        disp(['Loaded csi for',spth])
    catch err
        disp(['ERROR in loading csi',err.message])
        continue
    end
    %% linear fitting
    %     for jj = 1:size(csi_data_one,1)
    %         csi_data_one(jj,:) = csi_sanitization(csi_data_one(jj,:));
    %     end
    %% streamline and phase unroll(can provide a observation figure)
    %     subcarrier_filtered=20;
    %     subcarrier_selected=10;
    %     fc=5.825e9;
    %     deltaf=2e7/64*2;
    %     alpha_correlation=0.5;
    %     upper_order = 6;
    %     upper_stop = 60;
    %     lower_order = 3;
    %     lower_stop = 2;
    %     sample_rate=1000;
    %     csi_data_each_receiver_filtered_follower = bandpass_filter(csi_data_one,upper_order,lower_order, upper_stop, lower_stop, sample_rate / 2);
    % %     csi_data_each_receiver_filtered_follower = csi_data_one;
    %     [csi_data_each_receiver_filtered_follower,csi_subcarriers_index_selected_follower] = subcarrier_selection_var_filter(csi_data_each_receiver_filtered_follower,n_antennas,n_subcarriers,subcarrier_filtered,fc,deltaf);
    %     [csi_data_each_receiver_selected_follower,csi_subcarriers_index_selected_follower] = subcarrier_selection_correlation_filter(csi_data_one,csi_data_each_receiver_filtered_follower,n_antennas,subcarrier_filtered,subcarrier_selected,alpha_correlation,csi_subcarriers_index_selected_follower);
    %     csi_data_each_receiver_selected_follower=csi_data_each_receiver_selected_follower./abs(csi_data_each_receiver_selected_follower);
    %
    %     generate_streamline(1,csi_data_each_receiver_selected_follower',30,40,1,1)
    %     csi_phase=phase_output(csi_data_one,n_antennas,n_subcarriers);
    %% power and polynomial fitting
    csi_data_one=abs(csi_data_one).^2;
%         csi_data{receiver_index}=csi_data_one(1:end-1000,:);
    csi_data{receiver_index}=csi_data_one;
end
end