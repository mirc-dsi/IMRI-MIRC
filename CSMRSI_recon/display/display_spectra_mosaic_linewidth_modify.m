function display_spectra_mosaic_linewidth_modify(mrs_spectra,mrs_spectra_recon,origdata_max)
%mrs_spectra = mrs_spectra/max(abs(mrs_spectra(:)));
% mrs_spectra = mrs_spectra/origdata_max;

D = size(mrs_spectra);
num_col2 = D(1);
num_col1 = D(2);
Nsamples = D(3);
if (nargin <2)
figure;        
for k=1:D(1)
    Fdisp =[];
    for j = 1:D(2)

             
    %% Display
        F_norm =squeeze(mrs_spectra(k,j,:));
        F = ((D(1)-k+1))+real(F_norm);
        Fdisp = cat(1,Fdisp,F);
        plot(Fdisp);hold on;
        axis([0 16385 0 1]);
        drawnow;
       
    end
end

else
        %mrs_spectra_recon = mrs_spectra_recon/max(abs(mrs_spectra_recon(:)));
%         mrs_spectra_recon = mrs_spectra_recon/origdata_max;
        zz = zeros(num_col2,Nsamples*num_col1);
        zz2 = zeros(num_col2,Nsamples*num_col1);

    %% 

    for k1=1:num_col2
        s =[];
        for k2 =1:num_col1
             s_new = squeeze(abs(mrs_spectra(k1,k2,:)));
             s = [s; s_new]; 
        end
         zz(k1,:) = s;
    end
%% 
for k1=1:num_col2
        s =[];
        for k2 =1:num_col1
             s_new = squeeze(abs(mrs_spectra_recon(k1,k2,:)));
             s = [s; s_new]; 
        end
         zz2(k1,:) = s;
end


    %%

    figure;
    for i=1:num_col2
%         if(i==10)
%             sd=1;
%         end
        subplot(num_col2,1,i)
        plot (squeeze(zz(i,:)),'b','Linewidth',4);axis([0 (Nsamples*num_col1) 0 0.5]);hold on;
%                 plot (squeeze(zz(i,:)),'r');axis([0 (Nsamples*num_col1) 0 1]);hold on;

        plot (squeeze(zz2(i,:)),'r','Linewidth',2);axis([0 (Nsamples*num_col1) 0 0.5]);hold on;
                %plot (squeeze(zz2(i,:)),'g','Linewidth',0.5);axis([0 (Nsamples*num_col1) 0 1]);%hold on;

                        %plot (squeeze(zz2(i,:)),'c','Linewidth',0.5);axis([0 (Nsamples*num_col1) 0 1]);hold on;

        set(gca,'xtick',[],'ytick',[]);
    %     set(gca,'XTickmode','Manual','XTick',488);
    end
    % Reset the bottom subplot to have xticks
    set(gca,'xtickMode', 'auto');legend('Orig','Recon');
    
end