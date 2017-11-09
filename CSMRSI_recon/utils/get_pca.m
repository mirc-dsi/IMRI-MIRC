function [U,St,V]=get_pca(spectra_r1)
% S is the spectra to be denoised
 
% Reshape the spectra to apply svd 
Spectra_r_rs=reshape(spectra_r1,196,2048);
figure;imagesc(abs(Spectra_r_rs)); title('Reconstructed noisy data');
figure;plot(abs(Spectra_r_rs(100,:))); title('reconstructed noisy data');axis([0 2500 0 0.25]);

[U,S,V] = svd(Spectra_r_rs); %P=U*S*V'

%% Visualise S (diagonal elements) to set threshold

figure;imagesc(S);caxis([0 1]); title('visualise S to set threshold');
t1=1.15;%30 out of 196
%t1=0.2;% 106 out of 196
%t1=7;
St=S;
St(St<t1)=0;

