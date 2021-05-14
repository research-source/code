function cosine_similarity(index,n_antennas,corr_val_each_receiver)
lineS=["-.r*","--mo",":bs"];
figure(index);
for ii=1:n_antennas
    for jj=1:n_antennas
        if(ii==jj)
            plot((squeeze(corr_val_each_receiver(ii,jj,1:min(70,size(corr_val_each_receiver,3))))'),lineS(ii),'LineWidth',2);
        else
            plot((squeeze(corr_val_each_receiver(ii,jj,1:min(70,size(corr_val_each_receiver,3))))'),lineS(ii));
        end
        %                     plot(sgolayfilt(squeeze(corr_val_each_receiver(ii,:,1:min(60,size(corr_val_each_receiver,3))))',5,11));
        %         plot(squeeze(corr_val_each_receiver(ii,:,1:min(60,size(corr_val_each_receiver,3))))');
        %         legend([num2str(ii),'-1'],[num2str(ii),'-2'],[num2str(ii),'-3'])
        hold on;
    end
    %     title('Cosine Similarity for different antenna pair')
    xlabel('Sampling Tick Index');
    ylabel('Cosine Correlation');
    legend(['Header Antenna #I'],['Header Antenna #II'],['Header Antenna #III'])
    set(gcf,'WindowStyle','normal','Position', [200,200,960,480]);
end