function generate_streamline(figure_index,signal,x_dim,y_dim,interval_ratio,space)
figure(figure_index)
x_dim=min(size(signal,1),x_dim);
y_dim=min(size(signal,2),y_dim);
[x,y] = meshgrid(1:space:space*y_dim,1:space:space*x_dim);
x_data=real(signal);
y_data=imag(signal);
scale=max(max(max(abs(x_data))),max(max(abs(y_data))))*interval_ratio;
q=quiver(x,y,x_data(1:x_dim,1:y_dim)/scale,y_data(1:x_dim,1:y_dim)/scale);
% q.ShowArrowHead='off';
% for ii=1:space:space*(x_dim+1)
%     starty = 1:space:space*(y_dim+1);
%     startx = ii*ones(size(starty));
%     hlines=streamline(x,y,x_data(1:x_dim,1:y_dim)/scale,y_data(1:x_dim,1:y_dim)/scale,startx,starty);
%     set(hlines,'LineWidth',2,'Color','r')
%     hold on;
% end
% title('Empirical CDF of Subcarrier Distribution for Panel Path')
xlabel('Time Tick/ms');
ylabel('Subcarrier Index');
axis equal;
end