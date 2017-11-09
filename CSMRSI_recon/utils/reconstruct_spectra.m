function spectra = reconstruct_spectra(kspace)
kspace = (1/sqrt(numel(kspace))).*kspace;
kspace = ifftshift(kspace,1);
kspace = ifftshift(kspace,2);
spectra = ifftshift(fftn(kspace));




