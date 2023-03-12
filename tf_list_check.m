function [temp_list_out, freq_list_out] = tf_list_check(temp_list, freq_list)

% temp limits check
range = temp_list > 300;
temp_list(range) = 300;
range = temp_list < 10;
temp_list(range) = 10;

%freq limits check
range = freq_list > 10;
freq_list(range) = 10;
range = freq_list < 1/60;
freq_list(range) = 1/60;
freq_list = unique(freq_list);

% number of points
temp_N = numel(temp_list);
freq_N = numel(freq_list);

% time calc
single_time = sum(1./freq_list*5)/60; %m
full_time = numel(temp_list) * single_time/60; %h

% NOTE: magic constants
temp_rate = 1; % K/min
stabilization_time = 2; % min
temp_step = mean(abs(diff(temp_list))); % K
rate_add = (temp_step/temp_rate)*temp_N; % min
stab_add = stabilization_time*temp_N; % min
full_time = full_time + rate_add/60 + stab_add/60; %h

disp(['Number of temps: ' num2str(temp_N)]);
disp(['Number of freqs: ' num2str(freq_N)]);
disp(['Single time: ' num2str(single_time, '%0.2f') ' min']);
disp(['Full time: ' num2str(full_time, '%0.2f') ' hour']);

temp_list_out = temp_list;
freq_list_out = freq_list;

end