function [sampling_mask,usamp_actg] = samp_box_asym(D,usamp,center_sampling_density,center)
midx = center(1);
midy = center(2);
sampling_mask = zeros(D(1),D(2));

%% Obtain the center part of the sampling mask which is fully sampled.
num_lines_x = round(sqrt(center_sampling_density)*D(1));
num_lines_y = round(sqrt(center_sampling_density)*D(2));

xtop_x = round((midx) - num_lines_x/2);
xbot_x = round((midx) + num_lines_x/2 - 1);

xtop_y = round((midy) - num_lines_y/2);
xbot_y = round((midy) + num_lines_y/2 - 1);

sampling_mask(xtop_x:xbot_x,xtop_y:xbot_y,:)=1;
usamp_actg = sum(sampling_mask(:))/numel(sampling_mask);
%% Now obtain the other part of the mask weighted as 1/3 rd and 2/3 rd
if(usamp>center_sampling_density)
len_rem_top_x = xtop_x-1;
len_rem_bot_x = D(1)-xbot_x;

len_rem_top_y = xtop_y-1;
len_rem_bot_y = D(2)-xbot_y;


% Divide the length in the ratio of 1:2 so that samples can be divided
% accordingly.
% Looks complex code but is not actually.
% Get concentric squares and subtract to get masks for randn.
    
    num_remain_samp = round((usamp-center_sampling_density)*(D(1)*D(2) *0.5));
    
    
    maskparam.xtop_x = xtop_x;
    maskparam.xbot_x =xbot_x;
    maskparam.xtop_y = xtop_y;
    maskparam.xbot_y =xbot_y;
    
    maskparam.size = D;
    
    maskparam.len_rem_first_top_x = xtop_x - round((1/3)*len_rem_top_x);
    maskparam.len_rem_first_bottom_x = round((1/3)*len_rem_bot_x)+xbot_x;
    maskparam.len_rem_first_top_y = xtop_y - round((1/3)*len_rem_top_y);
    maskparam.len_rem_first_bottom_y = round((1/3)*len_rem_bot_y)+xbot_y;
    
    
    
    [aux_mask] = gen_aux_mask(maskparam,num_remain_samp,squeeze(sampling_mask(:,:,1)));
    
    
%     aux_mask1 = repmat(aux_mask,1,D(3));
%     aux_mask1 =reshape(aux_mask1,D(1),D(2),D(3));
%    
    aux_mask1 = aux_mask;
    sampling_mask = aux_mask1 + sampling_mask;
    usamp_actg = sum(sampling_mask(:))/numel(sampling_mask);

    
    
end


%% Generate a mask that is gives the sampled random pattern for the area
% required.
function aux_mask = gen_aux_mask(maskparam,num_remain_samp,samp_ref)
D = maskparam.size;
        
        %% Obtain the 2 masks first.
        
        % First mask covering 1/3rd of the remaining distance 
        samp_aux = zeros(D(1),D(2));
        samp_aux(maskparam.len_rem_first_top_x:maskparam.len_rem_first_bottom_x,maskparam.len_rem_first_top_y:maskparam.len_rem_first_bottom_y)=1;
        samp_aux1 = samp_aux -samp_ref;
       
        % Second mask covering 2/3rd of the rem distance
        samp_aux2 = ones(D(1),D(2)) - samp_aux;
       
        
        
        %% Now threshold based on the number of samples remaining.
        S = 1+ randn(D(1),D(2));
        % First aux mask
        aux_mask1 = samp_aux1.*S;
        [~,I] = sort(aux_mask1(:),'descend');
        aux_mask_c1 = zeros(D(1),D(2));
        aux_mask_c1(I(1:num_remain_samp)) =1;
        
        % Second_mask
        aux_mask2 = samp_aux2.*S;
        [~,I] = sort(aux_mask2(:),'descend');
        aux_mask_c2 = zeros(D(1),D(2));
        aux_mask_c2(I(1:num_remain_samp)) =1;
        
        aux_mask = aux_mask_c1 +aux_mask_c2;
%       imagesc(aux_mask);
