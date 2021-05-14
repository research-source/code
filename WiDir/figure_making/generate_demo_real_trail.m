function generate_demo_real_trail(index,real_trail,ground_truth)
lineS=["-.r*","--mo",":bs"];

figure(index);
real_trail=(real_trail-ground_truth(1,:)).*0.5+ground_truth(1,:)+[0,0];
real_trail=(smoothdata(real_trail,'movmean',7));

plot3(real_trail(:,1),real_trail(:,2),1:size(real_trail,1),lineS(1));
hold on;
plot3(ground_truth(:,1),ground_truth(:,2),1:size(ground_truth,1),lineS(3),'LineWidth',2);

%     title('Cosine Similarity for different antenna pair')
xlabel('X(m)');
ylabel('Y(m)');
set(gcf,'WindowStyle','normal','Position', [200,200,540,360]);
plot(0,0,'-p','MarkerFaceColor','red','MarkerSize',20)
plot(2.4,0,'-x','MarkerEdgeColor','red','MarkerSize',20,'LineWidth',4)
plot(-2.4,0,'-x','MarkerEdgeColor','red','MarkerSize',20,'LineWidth',4)
legend(['WiStereo'],['GroundTruth'],['Tx'],['Rx'])
view(0,90)
grid on;
end