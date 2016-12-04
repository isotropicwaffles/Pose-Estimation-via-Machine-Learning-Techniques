

struct = hyp_data;

ydata = [struct.val_acc];
ydata = ydata(end,:);
[val indx]=sort(ydata,'descend');
for ii = 1:numel(struct)
    
   struct(ii).val_acc = ydata(ii); 
   
end
   

struct = struct(indx);



figure;plot([struct.layer1_filter_size],'.b'); hold on
plot([struct.layer1_depth],'.m')
plot([struct.layer1_stride],'.r')



size_shit = double([struct.layer1_filter_size])./double([struct.layer2_filter_size]);

depth_shit = double([struct.layer2_depth])./double([struct.layer1_depth]);

val_shit = [struct.val_acc];
indx = find([struct.layer1_stride] == 1 & [struct.layer2_stride] == 1)

% figure;plot(temp_shit(indx),'.b'); hold on
% figure;plot(temp_shit,'.b'); hold on
% 
% figure;plot(depth_shit.*size_shit,'.b'); hold on
% figure;plot(depth_shit(indx).*size_shit(indx),'.b'); hold on
% 
% [depth size1]=meshgrid(unique(depth_shit),unique(size_shit))
% val = depth;
% val_shit = val_shit(indx);
% depth_shit = depth_shit(indx);
% size_shit = size_shit(indx);
% for ii = 1:size(depth,1)
%     for jj = 1:size(depth,2)
%         
%        val(ii,jj) = val_shit(depth_shit == depth(ii,jj) & size_shit == size1(ii,jj));
%     end
% end
% figure;plot3(depth_shit,size_shit,val_shit,'.')
% xlabel('depth ratio');ylabel('size ratio');zlabel('val acc');
% griddata(
% plot([struct.layer1_depth],'.m')
% plot([struct.layer1_stride],'.r')