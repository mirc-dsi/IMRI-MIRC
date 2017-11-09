function kspace= reconstruct_kspace(spectra,mask)
% function kspace= reconstruct_kspace(spectra,mask)
% reconstructs k-space from spectra.
if(nargin <2)
    mask = ones(size(spectra));
end

kspace = zeros(size(spectra));
for nx =1:size(kspace,1)
    for ny =1:size(kspace,2)
    kspace(nx,ny,:) = fft(fftshift(squeeze(spectra(nx,ny,:))));
    end
end

kspace = kspace.*mask;


