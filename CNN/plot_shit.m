function plot_shit(struct,x_field,y_field,last_only_flag,count_flag)

if exist('count_flag') && count_flag
   xdata = 1:numel(struct)
   
else
    xdata = [struct.(x_field)];

end
   
ydata = [struct.(y_field)];

if last_only_flag
    figure;plot(xdata,ydata(end,:),'o')
        
    %sum(isnan(ydata(end,:)))
end



end