function mesh_generated(index,signal)
figure(index);
colormap(jet);
mesh(1:size(signal,2),1:size(signal,1),signal(:,:));view([0,90]);
xlim([0,size(signal,2)]);ylim([0,size(signal,1)]);
%                             set(gcf,'WindowStyle','normal','Position', [300,300,400,250]); % window size
% set(gcf,'WindowStyle','normal','Position', [750*(ll-1)+250*(mm-1),300*(nn-1),300,250]); % window size
set (gca,'color','none', 'fontsize', 12); % fontsize
% set(gca,'yTick',[-size_y,size_y]);
xlabel('Time (ms)'); % x label
ylabel('Subcarrier'); % y label
colorbar; %Use colorbar only if necessary
% caxis([min(signal(:)),max(signal(:))]);
end