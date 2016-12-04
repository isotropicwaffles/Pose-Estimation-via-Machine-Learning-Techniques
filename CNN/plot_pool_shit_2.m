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


%Plot type 1

figure;

%filter size1
ix = ([true_data.layer2_pool_filter_size] == 2 & ...
    [true_data.layer1_pool_stride] == 2 & ...
    [true_data.layer2_pool_stride] == 2);


tempx = [struct.layer1_pool_filter_size];
tempy_size1_acc = val_shit(ix);
tempy_size1 = val_shit(ix)-train_shit(ix);

subplot(2,2,1);
[hAx,hLine1,hLine2] = plotyy(tempx(ix),tempy_size1,tempx(ix),tempy_size1_acc)
title('Pooling Layer 1 Filter Size')
hLine1.LineStyle = '--';
hLine1.Marker = 'o';
hLine2.LineStyle = '--';
hLine2.Marker = 'o';

ylabel(hAx(1),'Val. Acc. - Train Acc.') % left y-axis
%filter size2
ix = ([true_data.layer1_pool_filter_size] == 2 & ...
    [true_data.layer1_pool_stride] == 2 & ...
    [true_data.layer2_pool_stride] == 2);

tempy_size2_acc  = val_shit(ix);
tempy_size2 = val_shit(ix)-train_shit(ix);

tempx = [struct.layer2_pool_filter_size];
subplot(2,2,3);

[hAx,hLine1,hLine2] = plotyy(tempx(ix),tempy_size2,tempx(ix),tempy_size2_acc)
xlabel('Filter Size')
hLine1.LineStyle = '--';
hLine1.Marker = 'o';
hLine2.LineStyle = '--';
hLine2.Marker = 'o';
title('Pooling Layer 2 Filter Size')
ylabel(hAx(1),'Val. Acc. - Train Acc.') % left y-axis
%filter stride1
ix = ([true_data.layer2_pool_filter_size] == 2 & ...
    [true_data.layer1_pool_filter_size] == 2 & ...
    [true_data.layer2_pool_stride] == 2);

tempy_stride1_acc  = val_shit(ix);
tempy_stride1 = val_shit(ix)-train_shit(ix);

tempx = [struct.layer1_pool_stride];
subplot(2,2,2);
[hAx,hLine1,hLine2] = plotyy(tempx(ix),tempy_stride1,tempx(ix),tempy_stride1_acc)
title('Pooling Layer 1 Stride')
hLine1.LineStyle = '--';
hLine1.Marker = 'o';
hLine2.LineStyle = '--';
hLine2.Marker = 'o';
ylabel(hAx(2),'Val. Acc.') % right y-axis

%filter stride2
ix = ([true_data.layer1_pool_filter_size] == 2 & ...
    [true_data.layer2_pool_filter_size] == 2 & ...
    [true_data.layer1_pool_stride] == 2);

tempy_stride2_acc  = val_shit(ix);
tempy_stride2 = val_shit(ix)-train_shit(ix);

tempx = [struct.layer2_pool_stride];
subplot(2,2,4);
[hAx,hLine1,hLine2] = plotyy(tempx(ix),tempy_stride2,tempx(ix),tempy_stride2_acc)
hLine1.LineStyle = '--';
hLine1.Marker = 'o';
hLine2.LineStyle = '--';
hLine2.Marker = 'o';
title('Pooling Layer 2 Stride')
xlabel('Stride')
ylabel(hAx(2),'Val. Acc.') % right y-axis

%plot type 2


figure;

%filter size1
ix = ([true_data.layer2_pool_filter_size] == 2 & ...
    [true_data.layer1_pool_stride] == 2 & ...
    [true_data.layer2_pool_stride] == 2);


tempx = [struct.layer1_pool_filter_size];
tempy_size1_acc = val_shit(ix);
tempy_size1 = train_shit(ix);
subplot(2,2,1);
plot(tempx(ix),tempy_size1,'--ob');
hold on; plot(tempx(ix),tempy_size1_acc,'--or')
ax = gca;
xlim =ax.XLim;
plot(xlim,[64.78 64.78],'--k')
title('Pooling Layer 1 Filter Size')

ylabel('Acc.') % right y-axis
%filter size2
ix = ([true_data.layer1_pool_filter_size] == 2 & ...
    [true_data.layer1_pool_stride] == 2 & ...
    [true_data.layer2_pool_stride] == 2);

tempy_size2_acc  = val_shit(ix);
tempy_size2 =train_shit(ix);

tempx = [struct.layer2_pool_filter_size];
subplot(2,2,3);

plot(tempx(ix),tempy_size2,'--ob');
hold on; plot(tempx(ix),tempy_size2_acc,'--or')
ax = gca;
xlim =ax.XLim;
plot(xlim,[64.78 64.78],'--k')
xlabel('Filter Size')

title('Pooling Layer 2 Filter Size')
ylabel('Acc.') % right y-axis
%filter stride1
ix = ([true_data.layer2_pool_filter_size] == 2 & ...
    [true_data.layer1_pool_filter_size] == 2 & ...
    [true_data.layer2_pool_stride] == 2);

tempy_stride1_acc  = val_shit(ix);
tempy_stride1 =train_shit(ix);

tempx = [struct.layer1_pool_stride];
subplot(2,2,2);
plot(tempx(ix),tempy_stride1,'--ob');
hold on; plot(tempx(ix),tempy_stride1_acc,'--or')
ax = gca;
xlim =ax.XLim;
plot(xlim,[64.78 64.78],'--k')
title('Pooling Layer 1 Stride')

%filter stride2
ix = ([true_data.layer1_pool_filter_size] == 2 & ...
    [true_data.layer2_pool_filter_size] == 2 & ...
    [true_data.layer1_pool_stride] == 2);

tempy_stride2_acc  = val_shit(ix);
tempy_stride2 = train_shit(ix);

tempx = [struct.layer2_pool_stride];
subplot(2,2,4);
plot(tempx(ix),tempy_stride2,'--ob');
hold on; plot(tempx(ix),tempy_stride2_acc,'--or')
ax = gca;
xlim =ax.XLim;
plot(xlim,[64.78 64.78],'--k')
title('Pooling Layer 2 Stride')
xlabel('Stride')
legend('Train.','Val.','BL Mean Val.')

end