
% TODO: CHECK GAIN VALUE

addpath(genpath('../Ammeter class/'));
addpath(genpath('../Lakeshore325/'));
addpath(genpath('../LCR Keysight matlab/'));
addpath(genpath('.'));

clc

% settings
amp_measureing = 80; %V 280 for experiment, 80 for oom temp test
voltage_gain = 270; %FIXME: CHECK VALUE
voltage_divider = 115.5;
ramp_rate = 1; % K/min
output_folder = create_folder('Output_2023_03_13');

% experiment obj
exp_obj = Experiment(295, 80, 5, 'freq_fast'); % start stop step freq_list

% devices handles create
LCR_device = KeysightLCR();
FEloop_device = Ammeter('COM3', 'nyan', 'bias');
Temp_ctrl_device = Lakeshore325('COM0');

% init controller and wait for user
Temp_controller_init(Temp_ctrl_device, exp_obj, ramp_rate);
temp_actual = exp_obj.get_init_temp();
wait_user_input(); % wait user input

% create figure for temp graph and loop drawing
Feloop_fig = figure;

% start measuring
FEloop_device.connect();
Timer = tic;
try
% -------------- main part --------------
temp_list_ended = false;
while ~temp_list_ended
    [actual_temp, ~] = exp_obj.get_temp();
    if ~temp_list_ended
        temp_actual = exp_obj.get_temp();
        [temp_number, temp_list_size] = exp_obj.get_temp_number;
        disp(['Temp: ' num2str(temp_actual) ' K (' ...
            num2str(temp_number) '/' num2str(temp_list_size) ')'])
        
        % set_temp()
        Temp_ctrl_device.set_setpoint(temp_actual);
        temp_graph = [];
        k = 0;
        stable = false;
        while ~stable
            disp('-----------NEW SETPOINT-----------')
            k = k + 1;
            temp_graph.time(k) = toc(Timer); % s
            temp_graph.temp(k) = Temp_ctrl_device.get_temp(); % K
            temp_graph.heater(k) = Temp_ctrl_device.get_heater_value(); % [%]
            temp_graph.res(k) = LCR_device.get_res(); % Ohm
            
            range = temp_graph.time >= (temp_graph.time(end) - 60);
            if numel(find(range)) > 10
                last_min_span = diff(minmax(temp_graph.res(range)));
                full_span = diff(minmax(temp_graph.res));
                stable_value = last_min_span/full_span;
            else
                stable_value = 1;
            end
            
            time_passed = temp_graph.time(end) - temp_graph.temp(1); %s
            
            %FIXME: magic constants (3 lines)
            cond_1 = abs(temp_graph.temp(k) - temp_actual) < 0.05;
            cond_2 = stable_value < 0.05;
            cond_3 = time_passed/60 > 1;
            stable = (cond_1 && cond_2) || cond_3; %stable condition
            
            plot_time = (temp_graph.time - temp_graph.time(1))/60; %m
            figure(Temp_fig)
            subplot(3, 1, 1)
                plot(plot_time, temp_graph.temp, 'b')
                xlabel('t, m')
                title('Temp, K')
            subplot(3, 1, 2)
                plot(plot_time, temp_graph.res, 'b')
                xlabel('t, m')
                title('PT1000, Ohm')
            subplot(3, 1, 3)
                plot(plot_time, temp_graph.heater, 'b')
                xlabel('t, m')
                title('Heater, %')
        end
        
        % get_loops
        freq_list = exp_obj.get_freq_list();
%         freq_list_size = numel(freq_list);
        freq_list_size = 5;
        clearvars Loops
        for i = 1:freq_list_size
            freq = freq_list(i);
            period_actual = 1/freq;
            disp(['    Period: ' num2str(period_actual) ' s (' ...
                num2str(i) '/' num2str(freq_list_size) ')' ...
                ' Temp: ' num2str(temp_actual) ' K (' ...
                num2str(temp_number) '/' num2str(temp_list_size) ')']);
            Loop_opts = loop_options('amp', amp_measureing, ...
                                     'gain', voltage_gain, ...
                                     'divider', voltage_divider, ...
                                     'period', period_actual, ...
                                     'delay', 0.1);
            Loops(i) = hysteresis_PE_DWM(FEloop_device, Loop_opts, Feloop_fig);
        end
        % save_results;
        file_name = [num2str(temp_number, '%03u') '.mat'];
        file_addr = [output_folder '/' file_name];
        save(file_addr, 'Loops', 'temp_actual', 'temp_graph', 'freq_list')

        temp_list_ended = true;
    end
end
% ------------ main part end ------------
catch err
    FEloop_device.disconnect();
    Temp_controller_stop(Temp_ctrl_device)
    clearvars LCR_device Temp_ctrl_device FEloop_device

    time_passed_h = toc(Timer)/3600; %h

    msg = [err.message newline ...
       'file: ' err.stack.file newline ...
       'line: ' num2str(err.stack.line) newline ...
       'after ' num2str(time_passed_h) ' h passed'];
    error(msg);
end


FEloop_device.disconnect();
Temp_controller_stop(Temp_ctrl_device)
clearvars LCR_device Temp_ctrl_device FEloop_device

time_passed_h = toc(Timer)/3600; %h
disp(['Program closed (' num2str(time_passed_h) ' h)'])



