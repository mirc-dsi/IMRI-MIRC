function m1 = ncg(x,B,mask,data,maxIter,TVWeight,xfmWeight,level,wname)
% function x=ncg(x,mask) provides the non-linear conjugate gradient soln 
% Functional is |Fu(m) -y|2 + @|phi(m)|1 + &|TV(m)|
params.l1Smooth = 1e-15;
params.pNorm =1;
params.TolGrad = 1e-30;
params.maxIter = maxIter;
params.xfmWeight = xfmWeight;
params.TVWeight =TVWeight;
c1 = 0.01;c2=0.005;
alpha =0.05;
beta=0.6;
m0 = get_iwcoff(x,B);
m1 =0;
maxlsiter =150;
lsiter=0;


%% Initialization
k=0;
g0 = fgrad(x,B,m0,mask,data,params,level,wname);
dm0 = -g0;
f0 =1;
f0_old = 2;

%% Iterations
% Line search parameter estimation using backtracking and Wolfe's conditions
while(((g0(:)'*g0(:)) > params.TolGrad)&&(k<maxIter))
        t=1;
        f0 = objective(m0,mask,data,x,params);
        
        %% Woolfe's terms.

%         s0 = abs(g0(:)'*d0(:));
%         W0 = c1*a*s0;         %Woolfe's condition 1 term
        % s1 = real(g1_c'*d0_c);
        % W1 = c2*s0;         %                   2 term
        % W2 = s1;            %                   3 term
        % W3 = ((2*c1) -1)*s0;%                   4 term  

        
        
        
        if ((abs(f0 - f0_old) < 1e-4))
            break;
        end
        
        m_temp = m0 + t.*dm0; 
        f1 = objective(m_temp,mask,data,x,params);
        fact = alpha.*t.* real((g0(:))'*dm0(:));


%              while ((((f1 - f0) > W0)|| (W1>=W2)||(W2>=W3))&&((er<lineiter))) %Strong Woolfe's condition
%              while (~((f1 - f0) <= W0)  && (er<lineiter)) %|| (~(real(s1)<= W1))
        while(f1 > (f0+fact) && (lsiter<maxlsiter))
            t = beta*t;
            f0 = objective(m0,mask,data,x,params);
            m_temp = m0 + t.*dm0; 
            f1 = objective(m_temp,mask,data,x,params);
            fact = alpha.*t.* real((g0(:))'*dm0(:));
            lsiter = lsiter +1;
        end
        
            m1 = m0 + t*dm0;
            disp([f0])
            [x,B]=get_wcoff(m1);
            g1 = fgrad(x,B,m1,mask,data,params,level,wname);
            
            % Conjugate gradient calculation
            gamma = ((g1(:)'*g1(:)))/((g0(:)'*g0(:))+ eps);
            dm1 = -g1 + gamma*dm0;
         
            % Variables for next iteration
            k = k+1;
            dm0 = dm1;
            m0 =m1;
            g0 = g1;
            f0_old =f0;
 
end

%% Calculate objective
function f0 = objective(m,mask,data,x,params) 
p = params.pNorm;
data_con= (reconstruct_kspace(m,mask)-data);
data_con = data_con(:)'*data_con(:);

x2 = x(:);
sparsity_con = ((x2.*conj(x2))+params.l1Smooth).^(p/2);
% disp(sum(real(x(:))))
spars_sum = sum(params.xfmWeight*sparsity_con);

s = D3(m);
t = s(:);
TV_con = (t.*conj(t)+ params.l1Smooth).^(p/2);
TV_sum =sum(params.TVWeight*TV_con);

f0 = (data_con + spars_sum + TV_sum);


%% Calculate gradient
function gradx = fgrad(x,B,m,mask,data,params,level,wname)
p = params.pNorm;

% Data consistency factor
grad_objm =2*reconstruct_spectra((reconstruct_kspace(m,mask) - data));
[grad_obj,B] = get_wcoff(grad_objm);

% Sparsity factor
grad_sparsity = p*x.*(x.*conj(x)+params.l1Smooth).^(p/2-1);

% TV factor
Dx = D3(get_iwcoff(x,B));
G = p*Dx.*(Dx.*conj(Dx) + params.l1Smooth).^(p/2-1);
[grad_TV,~] = get_wcoff(adjD3(G));

grad = (grad_obj + params.xfmWeight.*grad_sparsity + params.TVWeight.*grad_TV);
gradx = get_iwcoff(grad,B);






