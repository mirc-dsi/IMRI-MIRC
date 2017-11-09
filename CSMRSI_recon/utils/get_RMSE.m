function RMSE = get_RMSE(m1,m2)
%m1 is the original and m2 is the reconstructed.
% m1 = abs(m1);
% m2= abs(m2);

% N = length(find(m1(:) ~=0));
% N/size(m1,3)

%% Normalizing to ensure removal of scaling factors in error determination
m1 = m1./max(abs(m1(:)));
m2 = m2./max(abs(m2(:)));

dist = (m1 - m2).^2;
RMSE = (sqrt(sum(dist(:))/numel(m1)));


