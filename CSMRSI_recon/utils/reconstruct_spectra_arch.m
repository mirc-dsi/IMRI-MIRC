function spectra = reconstruct_spectra(kspace)
% kspace = (1/sqrt(numel(kspace))).*kspace;
% kspace = ifftshift(kspace,1);
% kspace = ifftshift(kspace,2);
% spectra = ifftshift(fftn(kspace));
spectra = zeros(size(kspace));
for nx =1:size(kspace,1)
    for ny =1:size(kspace,2)
    spectra(nx,ny,:) = ifftshift(ifft(squeeze(kspace(nx,ny,:))));
    end
end





