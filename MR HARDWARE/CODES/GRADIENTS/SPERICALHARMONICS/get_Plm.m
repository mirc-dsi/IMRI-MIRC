function P_total = get_Plm(L,m,theta)
%%
x=cos(theta);
m = abs(m);
P = zeros(L+1,m);


                for l=m:L 

                        if l==m
                            P(l+1,m+1)=get_P1(m,x);%P(l,m) adding 1 to both to be compliant with Matlab syntax (a)
                        elseif l==m+1
                             P(m+2,m+1)=get_P2((m),x,P(m+1,m+1)); %(b)
                        else
                            P(l+1,m+1)= get_P_total(l,(m),x,P(l,m+1),P(l-1,m+1)); %(c)
                        end
                end
                

P_total = P(l+1,m+1);
