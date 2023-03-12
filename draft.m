addpath(genpath('../Ammeter class/'));
addpath(genpath('../Криостат 417/'));
addpath(genpath('../LCR Keysight matlab/'));
addpath(genpath('.'));

amp_measureing = 280; %V
voltage_gain = 262; %FIXME: CHECK VALUE
ramp_rate = 1; % K/min
exp_obj = Experiment(295, 80, 5, 'freq_mid'); % start stop step freq_list

% devices handles create
LCR_device = KeysightLCR();
FEloop_device = Ammeter('COM0', 'nyan', 'bias');
Temp_ctrl_device = Lakeshore325('COM0');

Temp_controller_init(Temp_ctrl_device, exp_obj, ramp_rate);
temp_actual = exp_obj.get_init_temp();

% FIXME: wait stable here

% create figure for loop drawing
Feloop_fig = figure;


% start measuring
disconnected = false;
FEloop_device.connect();
try
% -------------- main part --------------
temp_list_ended = 0;
while ~temp_list_ended
    [actual_temp, temp_list_ended] = exp_obj.get_temp();
    if ~temp_list_ended

        % set_temp()
        % get temp_graph here
        % update temp_actual
        
        % get_loop
        Loop_opts = loop_options('amp', amp_measureing, ...
                                 'gain', voltage_gain, ...
                                 'period', period_actual);
        feloop = hysteresis_PE_DWM(FEloop_device, Loop_opts, Feloop_fig);

        % save_results;
        file_name = [num2str(exp_obj.get_temp_number, '%03u') '.mat'];
        save(file_name, 'feloop', 'temp_actual', 'temp_graph')
    end
end
% ------------ main part end ------------
catch
    FEloop_device.disconnect();
    Temp_controller_stop(Temp_ctrl_device)
    clearvars LCR_device Temp_ctrl_device FEloop_device
    disconnected = true;
end

if ~disconnected
    FEloop_device.disconnect();
    Temp_controller_stop(Temp_ctrl_device)
    clearvars LCR_device Temp_ctrl_device FEloop_device
    disconnected = true;
end




