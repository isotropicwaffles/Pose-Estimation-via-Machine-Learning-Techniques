function [ formated_data ] = load_python_data(file_name)
%Loads that python shit and formats

flag = 2;
temp = load(file_name);
fields = fieldnames(temp.inputs);

formated_data = [temp.results{:}];

fields2 = fieldnames(formated_data);


for jj=1:numel(fields)
    temp_struct.(fields{jj}) = [];
end

switch flag
    
    case 1
        %Method 1 where it stores input struct
        for ii = 1:length(formated_data)
            formated_data(ii).input = temp_struct;
        end
        
        for ii = 1:length(formated_data)
            for jj=1:numel(fields)
                formated_data(ii).input.(fields{jj}) =...
                    temp.inputs.(fields{jj})(ii);
            end
        end
        
    case 2
        
        for ii = 1:length(formated_data)
            for jj=1:numel(fields)
                formated_data(ii).(fields{jj}) =...
                    temp.inputs.(fields{jj})(ii);
            end
            
            
            for jj = 1:numel(fields2)
                
                formated_data(ii).(fields2{jj}) =...
                    formated_data(ii).(fields2{jj})';
            end
        end
end

end

