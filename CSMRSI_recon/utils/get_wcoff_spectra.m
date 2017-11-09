function [W,B]=get_wcoff(spectra)

Sinit = squeeze(spectra(1,1,:));
[A,B]=wavedec(Sinit,4,'db4');

W = zeros([size(spectra,1) size(spectra,2) length(A)]);

for k=1:size(W,1)
    for h=1:size(W,2)
        [A,B]= wavedec(squeeze(real(spectra(k,h,:))),4,'db4');
        [C,B]= wavedec(squeeze(imag(spectra(k,h,:))),4,'db4');
        W(k,h,:) =A +1i*C;
    end
end