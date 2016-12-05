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
%[val indx]=sort(ydata,'descend');
for ii = 1:numel(struct)
    
   struct(ii).val_acc = ydata(ii); 
   
end
   

%struct = struct(indx);
val_shit = [struct.val_acc];



%Basline (%66.6667)

ix = (layer1_filter_size == [struct.layer1_filter_size] & ...
      layer2_filter_size == [struct.layer2_filter_size] & ...
      layer1_depth == [struct.layer1_depth] & ...
      layer2_depth == [struct.layer2_depth] & ...
      layer1_stride == [struct.layer1_stride] & ...
      layer2_stride == [struct.layer2_stride])
  
  
  val_shit(ix)
  
  
  

%(20,8) -> (10,16) (60.9195)

ix = (20 == [struct.layer1_filter_size] & ...
      10 == [struct.layer2_filter_size] & ...
      8 == [struct.layer1_depth] & ...
      16 == [struct.layer2_depth] & ...
      layer1_stride == [struct.layer1_stride] & ...
      layer2_stride == [struct.layer2_stride])
  
  
  val_shit(ix)
  
  
%(20,16) -> (10,64) (62.0690)

ix = (20 == [struct.layer1_filter_size] & ...
      10 == [struct.layer2_filter_size] & ...
      16 == [struct.layer1_depth] & ...
      64 == [struct.layer2_depth] & ...
      layer1_stride == [struct.layer1_stride] & ...
      layer2_stride == [struct.layer2_stride])
  
  
  val_shit(ix)
  
  
    
%(10,64) -> (20,16)  (64.3678)

ix = (10 == [struct.layer1_filter_size] & ...
      20 == [struct.layer2_filter_size] & ...
      64 == [struct.layer1_depth] & ...
      16 == [struct.layer2_depth] & ...
      layer1_stride == [struct.layer1_stride] & ...
      layer2_stride == [struct.layer2_stride])
  
  
  val_shit(ix)
  
  
  %(10,16) -> (20,8)  (64.3678)

ix = (10 == [struct.layer1_filter_size] & ...
      20 == [struct.layer2_filter_size] & ...
      16 == [struct.layer1_depth] & ...
      8 == [struct.layer2_depth] & ...
      layer1_stride == [struct.layer1_stride] & ...
      layer2_stride == [struct.layer2_stride])
  
  
  val_shit(ix)
  