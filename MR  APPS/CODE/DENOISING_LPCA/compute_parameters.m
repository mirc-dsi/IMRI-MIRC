function [theta,denoised_patch]=compute_parameters(patch1)
     
%% To explore for Seema - TODO
% noise variance from data
% normalizing X; column wise or otherwise
% normalizing Xhat?


 %% Function to calculate covarience, theta,denoised patch for evry input patch
dbstop if error;
 %% Normalization  has to be done per column
 [a,b,c,d] = size(patch1);
 X = reshape(patch1, [a*b*c,d]);
%% Mean normalization
   
  for col =1:d
     temp = squeeze(X(:,col));
     X(:,col) = (temp - mean(temp))./std(temp);
      X(:,col) = (temp - min(temp))./(max(temp) - min(temp));
 end
 

  %%     Compute Eigen Vector (W) and Eigen Values D
  covX=cov(X);%Calculate covarience matrix           
      [W,D]=eig(covX);% Calculate eigenvectors of covarience matrix %       D=diag(W); Please read carefully
      Y=X*W;   % Calculate Y=XW, Y gives new coordinates along the diagonal elements, X is input patch, W is diagonal matrix with nonzero digonal elements and other elements are zero
%        sigma = 0.08;% This needs to incorporate equations 7 and 8  
%       
      SNR=mean(X(:))./min(nonzeros(D));
      SNR=20*log10(SNR);
      sigma=var(X(:))./SNR;
      noise_variance=(2.3*sigma).^2; %Compute thresghold value by threshold =(2.3?).^2 where   is noise variance 
%      noise_variance=0.0015;%(2
      D(D< noise_variance) =0; 
 
 
%% Compute denoised patch

Xhat = abs(Y*(W'*D)');%This needs to be looked at closer - good for now as images are always positive

for col =1:d
     temp = squeeze(Xhat(:,col));
      Xhat(:,col) = (temp - mean(temp))./std(temp);
     Xhat(:,col) = (temp - min(temp(:)))./(max(temp) - min(temp));
end

 %% Reshape and compute theta with l0 norm
denoised_patch = reshape(Xhat, size(patch1));
Dj = nnz(D);
theta = 1./(1+Dj);


