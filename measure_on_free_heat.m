

addpath(genpath('../Ammeter class/'));
addpath(genpath('../Lakeshore325/'));
addpath(genpath('../LCR Keysight matlab/'));
addpath(genpath('.'));

clc

% settings
voltage_gain = 270;
voltage_divider = 115.5;
output_folder = create_folder('Output_2023_03_21');

% devices handles create
LCR_device = KeysightLCR();
FEloop_device = Ammeter('COM3', 'nyan', 'bias');
Temp_ctrl_device = Lakeshore325('COM2');

% init controller and wait for user
LCR_device.set_volt(0.1); % V
LCR_device.set_freq(1000); % kHz
Temp_ctrl_device.set_ramp(false, 1); % turn off ramp
Temp_ctrl_device.set_setpoint(295); % set room temp
Temp_ctrl_device.set_ramp(true, 1); % turn on ramp
Temp_ctrl_device.set_heater_range(0); % turn on heater
wait_user_input(); % TODO: print exp params

% create figure for temp graph and loop drawing
Feloop_fig = figure;

% start measuring
FEloop_device.connect();
i = 0;
temp_graph = [];
% -------------- main part --------------
Temp_ab = Temp_ctrl_device.get_temp(); % K
temp_A = Temp_ab.a;
Timer = tic;
while temp_A < 280
    i = i + 1;
    Temp_ab = Temp_ctrl_device.get_temp(); % K
    temp_A = Temp_ab.a;
    disp(['|' num2str(i) '| Temp: ' num2str(temp_A) ' K']);
    
    temp_graph.time(i) = toc(Timer); % s
    temp_graph.temp(i) = temp_A;
    temp_graph.res(i) = LCR_device.get_res(); % Ohm

    freq = 1/20;
    amp = 450;
    
    Loop_opts = loop_options('amp', amp, ...
        'gain', voltage_gain, ...
        'divider', voltage_divider, ...
        'period', 1/freq, ...
        'delay', 0.3, ...
        'init_pulse', 0, ...
        'voltage_ch', 1);

    figure(Feloop_fig)
    cla
    Loops(i) = hysteresis_PE_DWM(FEloop_device, Loop_opts, Feloop_fig);
    Loops(i).period = 1/freq;
    Loops(i).amp = amp;
    Loops(i).init_pulse = 0;
    Loops(i).version = "V01.01.00";
    %TODO: add loop spec to loop struct


    % save_results;
    file_name = [num2str(temp_number, '%03u') '.mat'];
    file_addr = [output_folder '/' file_name];
    save(file_addr, 'Loops', 'temp_graph')

end
% ------------ main part end ------------



FEloop_device.disconnect();
Temp_controller_stop(Temp_ctrl_device)
clearvars LCR_device Temp_ctrl_device FEloop_device

time_passed_h = toc(Timer)/3600; %h
disp(['Program closed (' num2str(time_passed_h) ' h)'])




