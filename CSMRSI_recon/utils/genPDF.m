function [pdf,val] = genPDF(imSize,p,pctg,distType,radius,disp)

if nargin < 4
	distType = 2;
end

if nargin < 5
	radius = 0;
end

if nargin < 6
	disp = 0;
end


minval=0;
maxval=1;
val = 0.5;

if length(imSize)==1
	imSize = [imSize,1];
end

sx = imSize(1);
sy = imSize(2);
PCTG = floor(pctg*sx*sy);


if sum(imSize==1)==0  % 2D
	[x,y] = meshgrid(linspace(-1,1,sy),linspace(-1,1,sx));
	switch distType
		case 1
			r = max(abs(x),abs(y));
		otherwise
			r = sqrt(x.^2+y.^2);
			r = r/max(abs(r(:)));			
	end

else %1d
	r = abs(linspace(-1,1,max(sx,sy)));
end




idx = find(r<radius);

pdf = (1-r).^p; pdf(idx) = 1;
if floor(sum(pdf(:))) > PCTG
	error('infeasible without undersampling dc, increase p');
end

% begin bisection
while(1)
	val = minval/2 + maxval/2;
	pdf = (1-r).^p + val; pdf(find(pdf>1)) = 1; pdf(idx)=1;
	N = floor(sum(pdf(:)));
	if N > PCTG % infeasible
		maxval=val;
	end
	if N < PCTG % feasible, but not optimal
		minval=val;
	end
	if N==PCTG % optimal
		break;
	end
end

if disp
	figure, 
	subplot(211), imshow(pdf)
	if sum(imSize==1)==0
		subplot(212), plot(pdf(end/2+1,:));
	else
		subplot(212), plot(pdf);
	end
end






