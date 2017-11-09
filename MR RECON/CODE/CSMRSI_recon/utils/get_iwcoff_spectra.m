function [X,B]=get_iwcoff(W,B)

Sinit = squeeze(W(1,1,:));
X2 = waverec(Sinit,B,'db4');

X = zeros([size(W,1) size(W,2) length(X2)]);

for k=1:size(W,1)
    for h=1:size(W,2)
        [A]= waverec(squeeze(real(W(k,h,:))),B,'db4');
        [C]= waverec(squeeze(imag(W(k,h,:))),B,'db4');
        X(k,h,:) =A + 1i*C;
    end
end