function kspace= reconstruct_kspace(spectra,mask)
% function kspace= reconstruct_kspace(spectra,mask)
% reconstructs k-space from spectra.
  kspace = (ifftn(spectra));
  kspace =fftshift(kspace,1);
  kspace =fftshift(kspace,2);
  kspace = kspace.*mask;