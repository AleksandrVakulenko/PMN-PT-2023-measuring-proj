
% TODO: CHECK GAIN VALUE
% TODO: LCR class finish

addpath(genpath('../Ammeter class/'));
addpath(genpath('../Lakeshore325/'));
addpath(genpath('../LCR Keysight matlab/'));
addpath(genpath('.'));

% settings
amp_measureing = 280; %V
voltage_gain = 262; %FIXME: CHECK VALUE
ramp_rate = 1; % K/min
output_folder = create_folder('Output_2023_03_13');

% experiment obj
exp_obj = Experiment(295, 80, 5, 'freq_mid'); % start stop step freq_list

% devices handles create
LCR_device = KeysightLCR();
FEloop_device = Ammeter('COM0', 'nyan', 'bias');
Temp_ctrl_device = Lakeshore325('COM0');

% init controller and wait for user
Temp_controller_init(Temp_ctrl_device, exp_obj, ramp_rate);
temp_actual = exp_obj.get_init_temp();
wait_user_input(); % wait user input

% create figure for temp graph and loop drawing
Feloop_fig = figure;
Temp_fig = figure;

% start measuring
FEloop_device.connect();
Timer = tic;
try
% -------------- main part --------------
temp_list_ended = 0;
while ~temp_list_ended
    [actual_temp, temp_list_ended] = exp_obj.get_temp();
    if ~temp_list_ended
        
        % set_temp()
        temp_actual = exp_obj.get_temp();
        Temp_ctrl_device.set_setpoint(temp_actual);
        temp_graph = [];
        k = 0;
        stable = false;
        while ~stable
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

            cond_1 = abs(temp_graph.temp(k) - temp_actual) < 0.05;
            cond_2 = stable_value < 0.1;
            cond_3 = time_passed/60 > 25;
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
        
        % get_loop
        Loop_opts = loop_options('amp', amp_measureing, ...
                                 'gain', voltage_gain, ...
                                 'period', period_actual);
        feloop = hysteresis_PE_DWM(FEloop_device, Loop_opts, Feloop_fig);

        % save_results;
        file_name = [num2str(exp_obj.get_temp_number, '%03u') '.mat'];
        file_addr = [output_folder '/' file_name];
        save(file_name, 'feloop', 'temp_actual', 'temp_graph')
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




