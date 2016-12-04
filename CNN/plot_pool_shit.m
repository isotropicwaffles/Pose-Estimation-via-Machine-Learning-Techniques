function plot_pool_shit(struct)

%Best Validation = pool1_filter_size = 16
%                  pool2_filter_size = 8
%                  pool1_stride = 1
%                  pool2_stride = 2


  layer1_pool_filter_size_array = [2];
  layer1_pool_stride_array = [2];
  layer2_pool_filter_size_array = [2];
  layer2_pool_stride_array = [2];
  
  
   struct_size = numel(struct);
   
   temp_pool=[struct.pooling]
  true_data =struct(temp_pool == 1);
    false_data =struct(temp_pool == 0);

  val_shit_f = [false_data.val_acc];
val_shit_f=val_shit_f(end,:);
train_shit_f = [false_data.train_acc];
train_shit_f = train_shit_f(end,:);
    
mean(val_shit_f)
mean(train_shit_f)

mean(val_shit_f - train_shit_f)
  %struct = struct(indx);
val_shit = [true_data.val_acc];
val_shit=val_shit(end,:);
train_shit = [true_data.train_acc];
train_shit = train_shit(end,:);
%filter size1
ix = ([true_data.layer2_pool_filter_size] == 2 & ...
    [true_data.layer1_pool_stride] == 2 & ...
    [true_data.layer2_pool_stride] == 2);


tempx = [struct.layer1_pool_filter_size];
tempy = val_shit(ix)-train_shit(ix);
figure;plot(tempx(ix),tempy,'o--b'); hold on
title('size1')


%filter size2
ix = ([true_data.layer1_pool_filter_size] == 2 & ...
    [true_data.layer1_pool_stride] == 2 & ...
    [true_data.layer2_pool_stride] == 2);

tempy = val_shit(ix)-train_shit(ix);

tempx = [struct.layer2_pool_filter_size];
figure;plot(tempx(ix),tempy,'o--b'); hold on
title('size2')

%filter size1
ix = ([true_data.layer2_pool_filter_size] == 2 & ...
    [true_data.layer1_pool_filter_size] == 2 & ...
    [true_data.layer2_pool_stride] == 2);

tempy = val_shit(ix)-train_shit(ix);

tempx = [struct.layer1_pool_stride];
figure;plot(tempx(ix),tempy,'o--b'); hold on
title('stride1')


%filter size2
ix = ([true_data.layer1_pool_filter_size] == 2 & ...
    [true_data.layer2_pool_filter_size] == 2 & ...
    [true_data.layer1_pool_stride] == 2);

tempy = val_shit(ix)-train_shit(ix);

tempx = [struct.layer2_pool_stride];
figure;plot(tempx(ix),tempy,'o--b'); hold on
title('stride2')



%filter size1
ix = ([true_data.layer2_pool_filter_size] == 2 & ...
    [true_data.layer1_pool_stride] == 2 & ...
    [true_data.layer2_pool_stride] == 2);


tempx = [struct.layer1_pool_filter_size];
tempy = val_shit(ix);
figure;plot(tempx(ix),tempy,'o--b'); hold on
title('size1')


%filter size2
ix = ([true_data.layer1_pool_filter_size] == 2 & ...
    [true_data.layer1_pool_stride] == 2 & ...
    [true_data.layer2_pool_stride] == 2);

tempy = val_shit(ix);

tempx = [struct.layer2_pool_filter_size];
figure;plot(tempx(ix),tempy,'o--b'); hold on
title('size2')

%filter size1
ix = ([true_data.layer2_pool_filter_size] == 2 & ...
    [true_data.layer1_pool_filter_size] == 2 & ...
    [true_data.layer2_pool_stride] == 2);

tempy = val_shit(ix);

tempx = [struct.layer1_pool_stride];
figure;plot(tempx(ix),tempy,'o--b'); hold on
title('stride1')


%filter size2
ix = ([true_data.layer1_pool_filter_size] == 2 & ...
    [true_data.layer2_pool_filter_size] == 2 & ...
    [true_data.layer1_pool_stride] == 2);

tempy = val_shit(ix);

tempx = [struct.layer2_pool_stride];
figure;plot(tempx(ix),tempy,'o--b'); hold on
title('stride2')



end