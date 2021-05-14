function csi_phase =phase_output(csi_data,M,N)
time_length=size(csi_data,1);
csi_phase = zeros(time_length,M*N);
for ii=1:time_length
    for jj = 1:M
        if jj == 1
            csi_phase(ii,(jj-1)*N+1:jj*N) = unwrap(angle(csi_data(ii,(jj-1)*N+1:jj*N)));
        else
            csi_diff = angle(csi_data(ii,(jj-1)*N+1:jj*N).*conj(csi_data(ii,(jj-2)*N+1:(jj-1)*N)));
            csi_phase(ii,(jj-1)*N+1:jj*N) = unwrap(csi_phase(ii,(jj-2)*N+1:(jj-1)*N) + csi_diff);
        end
    end
    
    %     mesh(1:size(csi_phase,2),(time_index-1)*time_interval+1:time_index*time_interval,csi_phase((time_index-1)*time_interval+1:time_index*time_interval,:))
    %     for i=1:3
    %         figure(i)
    %         signal=csi_data((time_index-1)*time_interval+1:time_index*time_interval,1+(i-1)*30:30*i);
    %         plot((time_index-1)*time_interval+1:time_index*time_interval,mean(signal,2))
    %     end
end