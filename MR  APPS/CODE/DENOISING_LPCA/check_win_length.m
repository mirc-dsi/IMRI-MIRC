function [xr] = check_win_length(ax,bx,N)
L = bx - ax; %Length of patch
if((L < 2 ) && (ax ==1))
    xr = [ax, ax:bx];
elseif((L<2) && (bx ==N))
    xr = [ax:bx,bx];
else
    xr = ax:bx;
end

