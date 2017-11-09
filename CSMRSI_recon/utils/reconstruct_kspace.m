function kspace= reconstruct_kspace(spectra,mask)
% function kspace= reconstruct_kspace(spectra,mask)
% reconstructs k-space from spectra.
if(nargin <2)
    mask = ones(size(spectra));
end

%mask=ones(size(spectra));
kspace = ifftn(fftshift(spectra));
kspace = fftshift(kspace,1);
kspace = fftshift(kspace,2);

%mask=squeeze(mask(:,:,:,1));
kspace = (sqrt(numel(kspace))).*kspace.*mask;

