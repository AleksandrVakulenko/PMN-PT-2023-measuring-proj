


classdef Experiment < handle
% -----------------------methods------------------------------
methods(Access = public)
    function obj = Experiment(temp_start, temp_low, temp_step, loop_variant)
        disp('Experiment created:')
        [obj.temp_list, obj.loop_spec_list] = ft_gen(temp_start, temp_low, temp_step, loop_variant);
    end
    
    function [temp, finish] = get_temp(obj)
        if obj.actual_temp_n > numel(obj.temp_list)
            temp = obj.temp_list(end);
            finish = 1;
        else
            temp = obj.temp_list(obj.actual_temp_n);
            obj.actual_temp_n = obj.actual_temp_n + 1;
            finish = 0;
        end
    end
    
    function init_temp = get_init_temp(obj)
        init_temp = obj.temp_list(1);
    end

    function [number, list_size] = get_temp_number(obj)
        number = obj.actual_temp_n - 1; % NOTE: post-inc in get_temp
        list_size = numel(obj.temp_list);
    end

    function spec_list = get_loop_spec_list(obj)
        spec_list = obj.loop_spec_list;
    end
    
    
    

end

% ---------------------properties-----------------------------
properties(Access = private)
    temp_list = 295;
    
    loop_spec_list = struct('freq_list', 1, ...
        'amp_list', 0, ...
        'init_pulse_list', 0);

    actual_temp_n = 1;
end

end





% ----------------------------------------------------------------------------------------------


function [temp_list, loop_spec_list] = ft_gen(temp_start, temp_low, temp_step, loop_variant)

switch loop_variant
    case "freq_full"
        freq_list = 1./[0.1 0.2 0.5 0.75 1 1.5 2 3 5 7.5 10 ...
                        12 15 17.5 25 35 45 60];
    case "freq_mid"
        freq_list = 1./[0.1 0.2 0.5 1 2 5 10 20 60];
    
    case "freq_mid_fast"
        freq_list = 1./[0.1 0.2 0.5 1 2 5 10 30];
        
    case "freq_fast"
        freq_list = 1./[0.1 0.2 0.5 0.75 1 1.5 2 3 5 7.5 10];

    otherwise
        freq_list = 1./[0.1 0.2 0.5 1 2 5 10];

end


amp_list = [
    450
    400
    350
    300

    450
    400
    350
    300

    450
    400
    350
    300

    450
    400
    350
    300

    450
    400
    350
    300];


periods_list = [
    60
    60
    60
    60

    10
    10
    10
    10

    3
    3
    3
    3

    1
    1
    1
    1

    0.5
    0.5
    0.5
    0.5];



init_pulse_list = [
    1
    0
    0
    0

    1
    0
    0
    0

    1
    0
    0
    0

    1
    0
    0
    0

    1
    0
    0
    0];

freq_list = 1./periods_list;

err = false;
if numel(periods_list) ~= numel(amp_list)
    err = true;
end
if numel(periods_list) ~= numel(init_pulse_list)
    err = true;
end
if err 
    error('wrong sizes of loop spec list')
end

% temp_start = 295; %K
% temp_low = 80; %K
temp_final = temp_start;
% temp_step = 5; %K

temp_fall = [temp_start:-temp_step:temp_low];
temp_rise = [temp_low+temp_step:temp_step:temp_final];
temp_list = [temp_fall temp_rise];

loop_spec_list.freq_list = freq_list;
loop_spec_list.amp_list = amp_list;
loop_spec_list.init_pulse_list = init_pulse_list;

[temp_list, loop_spec_list] = tf_list_check(temp_list, loop_spec_list);


end



function [temp_list_out, loop_spec_list] = tf_list_check(temp_list, loop_spec_list)
freq_list = loop_spec_list.freq_list;
init_pulse_list = loop_spec_list.init_pulse_list;

% freq_list and temp limits check
range = temp_list > 300;
temp_list(range) = 300;
range = temp_list < 10;
temp_list(range) = 10;

%freq limits check
range = freq_list > 10;
freq_list(range) = 10;
range = freq_list < 1/60;
freq_list(range) = 1/60;
%NOTE: NOW WE could not use unique
% freq_list = unique(freq_list, 'stable');

% number of points
temp_N = numel(temp_list);
freq_N = numel(freq_list);

% time calc
number_of_loops = init_pulse_list + 4; %FIXME: ugly code, replace
single_time = sum(1./freq_list.*number_of_loops)/60; %m %FIXME: 5 is magic constant
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
loop_spec_list.freq_list = freq_list;

end


