batch_size = 10;
learning_rate = 0.01;
layer1_filter_size = 5;
layer1_depth = 16;
layer1_stride = 2;
layer2_filter_size = 5;
layer2_depth = 16;
layer2_stride = 2;
layer3_num_hidden = 64;
layer4_num_hidden = 64;
num_training_steps = 1501;

% ix = (layer1_filter_size == struct.layer1_filter_size & ...
%       layer2_filter_size == struct.layer2_filter_size & ...
%       layer1_depth == struct.layer1_depth & ...
%       layer2_depth == struct.layer2_depth & ...
%       layer1_stride == struct.layer1_stride & ...
%       layer2_stride == struct.layer2_stride)

struct = hyp_data;

ydata = [struct.val_acc];
ydata = ydata(end,:);
[val indx]=sort(ydata,'descend');
for ii = 1:numel(struct)
    
   struct(ii).val_acc = ydata(ii); 
   
end
   

%struct = struct(indx);
val_shit = [struct.val_acc];
% 
% %filter size
% ix = ([struct.layer2_filter_size] == [struct.layer1_filter_size] & ...
%       layer1_depth == [struct.layer1_depth] & ...
%       layer2_depth == [struct.layer2_depth] & ...
%       layer1_stride == [struct.layer1_stride] & ...
%       layer2_stride == [struct.layer2_stride])
% 
% tempx = [struct.layer1_filter_size];
% figure;plot(tempx(ix),val_shit(ix),'o--b'); hold on
% title('Layer1 = Layer2')
% 
% %depth
% ix = (layer1_filter_size == [struct.layer1_filter_size] & ...
%       layer2_filter_size == [struct.layer2_filter_size] & ...
%       [struct.layer2_depth] == [struct.layer1_depth] & ...
%       layer1_stride == [struct.layer1_stride] & ...
%       layer2_stride == [struct.layer2_stride])
% 
% tempx = [struct.layer2_depth];
% figure;plot(tempx(ix),val_shit(ix),'o--b'); hold on
% title('Depth1 = Depth2')
% 
% 
% %stride
% ix = (layer1_filter_size == [struct.layer1_filter_size] & ...
%       layer2_filter_size == [struct.layer2_filter_size] & ...
%       layer1_depth == [struct.layer1_depth] & ...
%       layer2_depth == [struct.layer2_depth] & ...
%       [struct.layer2_stride] == [struct.layer1_stride])
% 
% 
% tempx = [struct.layer2_stride];
% figure;plot(tempx(ix),val_shit(ix),'o--b'); hold on
% title('Stride1=Stride2');
% 

figure;
%filter size1
ix = (layer2_filter_size == [struct.layer2_filter_size] & ...
      layer1_depth == [struct.layer1_depth] & ...
      layer2_depth == [struct.layer2_depth] & ...
      layer1_stride == [struct.layer1_stride] & ...
      layer2_stride == [struct.layer2_stride])

tempx = [struct.layer1_filter_size];
figure;plot(tempx(ix),val_shit(ix),'o--b','LineWidth',2); hold on

ix = (layer1_filter_size == [struct.layer1_filter_size] & ...
      layer1_depth == [struct.layer1_depth] & ...
      layer2_depth == [struct.layer2_depth] & ...
      layer1_stride == [struct.layer1_stride] & ...
      layer2_stride == [struct.layer2_stride])

tempx = [struct.layer2_filter_size];
plot(tempx(ix),val_shit(ix),'o--r','LineWidth',2); hold on
title('Conv. Layers Filter Size')
ylabel('Acc.'); xlabel('Filter Size');
legend('Layer 1','Layer 2')
texify_plot





figure;
%Depth
ix = (layer1_filter_size == [struct.layer1_filter_size] & ...
      layer2_filter_size == [struct.layer2_filter_size] & ...
      layer2_depth == [struct.layer2_depth] & ...
      layer1_stride == [struct.layer1_stride] & ...
      layer2_stride == [struct.layer2_stride])

tempx = [struct.layer1_depth];
figure;plot(tempx(ix),val_shit(ix),'o--b','LineWidth',2); hold on

ix = (layer1_filter_size == [struct.layer1_filter_size] & ...
      layer2_filter_size == [struct.layer2_filter_size] & ...
      layer1_depth == [struct.layer1_depth] & ...
      layer1_stride == [struct.layer1_stride] & ...
      layer2_stride == [struct.layer2_stride])

tempx = [struct.layer2_depth];
plot(tempx(ix),val_shit(ix),'o--r','LineWidth',2); hold on
title('Conv. Layers Depth')
ylabel('Acc.'); xlabel('Depth');
legend('Layer 1','Layer 2')
texify_plot



figure;
%Stride
ix = (layer1_filter_size == [struct.layer1_filter_size] & ...
      layer2_filter_size == [struct.layer2_filter_size] & ...
      layer1_depth == [struct.layer1_depth] & ...
      layer2_depth == [struct.layer2_depth] & ...
      layer2_stride == [struct.layer2_stride])


tempx = [struct.layer1_stride];
figure;plot(tempx(ix),val_shit(ix),'o--b','LineWidth',2); hold on

ix = (layer1_filter_size == [struct.layer1_filter_size] & ...
      layer2_filter_size == [struct.layer2_filter_size] & ...
      layer1_depth == [struct.layer1_depth] & ...
      layer2_depth == [struct.layer2_depth] & ...
      layer1_stride == [struct.layer1_stride])

tempx = [struct.layer2_stride];
plot(tempx(ix),val_shit(ix),'o--r','LineWidth',2); hold on
title('Conv. Layers Stride')
ylabel('Acc.'); xlabel('Stride');
legend('Layer 1','Layer 2')
texify_plot




%stride1


figure;plot(tempx(ix),val_shit(ix),'o--b'); hold on
title('Stride1');



%filter size2

title('Layer2')

%depth2


figure;plot(tempx(ix),val_shit(ix),'o--b'); hold on
title('Depth2')


%stride2



figure;plot(tempx(ix),val_shit(ix),'o--b'); hold on
title('Stride2');