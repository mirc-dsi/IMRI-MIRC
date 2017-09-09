function P_total=get_P_total(l,m,x,pl2,pl1)
%P_total=Plm

    P1t = x.*((((2.*l)-1)/(l-m)).*pl2);
%     P2t = ((l+m+1)/(l-m)).*pl1;
    P2t = ((l+m-1)/(l-m)).*pl1;
    P_total=P1t - P2t;
