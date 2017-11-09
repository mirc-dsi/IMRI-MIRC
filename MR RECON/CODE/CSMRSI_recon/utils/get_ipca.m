function Spectra_denoised=get_ipca(U,St,V)
Spectra_denoised=U*St*V';
figure;imagesc(abs(Spectra_denoised)); title('Denoised Spectra');
figure;plot(abs(Spectra_denoised(100,:))); title('Denoised Spectra- 30 elements out of 196');axis([0 2500 0 0.25]);


