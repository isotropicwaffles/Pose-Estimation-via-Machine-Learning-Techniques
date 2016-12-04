aug_data = load_python_data('updated_results_11_8_16\cnn_data_aug_results.mat')
standard = load_python_data('updated_results_11_8_16\cnn_data_aug_results.mat')

drop_out_data = load_python_data('updated_results_11_8_16\cnn_drop_out_results.mat')
stop_early_data = load_python_data('updated_results_11_8_16\cnn_data_early_stop_final.mat')
weight_data = load_python_data('updated_results_11_8_16\cnn_weight_reg_results.mat')

display(['data aug performance: ' num2str(aug_data.val_acc(end))]);

temp = [drop_out_data.val_acc];
drop_out_y = temp(end,:);
drop_out_x = [drop_out_data.dropout_prob]

figure; plot(1-drop_out_x,drop_out_y,'--o'); hold on;
ax = gca;
xlim =ax.XLim;
plot(xlim,[64.78 64.78],'--k')
ylabel('Acc.'); xlabel('Drop Out Prob.');
title('Drop Out Performance')
texify_plot

figure;

temp = [stop_early_data.val_acc];
stop_early_data_y = temp(end,:);
stop_early_data_x = [stop_early_data.step]


temp = [weight_data.val_acc];
weight_data_y = temp(end,:);
weight_data_x = [weight_data.weight_penalty]

figure; plot(weight_data_x,weight_data_y,'--o'); hold on;
ax = gca;
xlim =ax.XLim;
plot(xlim,[64.78 64.78],'--k')
ylabel('Acc.'); xlabel('Weight');
title('Weight Regularization Performance')
texify_plot


aug_data.val_acc(end)


temp = [stop_early_data.val_acc];
stop_early_data_y = temp;
stop_early_data_x = stop_early_data.step

figure; plot(stop_early_data_x,stop_early_data_y,'--o'); hold on;
ax = gca;
xlim =ax.XLim;
plot(xlim,[64.78 64.78],'--k')
ylabel('Acc.'); xlabel('Steps');
title('Early Stopping Performance')
texify_plot