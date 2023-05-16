addpath(genpath('../Ammeter class/'));
addpath(genpath('.'));

clc

% settings
% voltage_gain = 270;
% voltage_divider = 115.5;
voltage_gain = 1000;
voltage_divider = 1000;
% output_folder = create_folder('Output_2023_05_15_PZT');


FEloop_device = Ammeter('COM3', 'nyan', 'bias');

% i = 1;
i = i + 1;

freq = 1/15;
amp = 630;

Loop_opts = loop_options('amp', amp, ...
    'gain', voltage_gain, ...
    'divider', voltage_divider, ...
    'period', 1/freq, ...
    'delay', 0.3, ...
    'init_pulse', 0, ...
    'voltage_ch', 1);

Feloop_fig = figure;
cla
Loops.feloop = hysteresis_PE_DWM(FEloop_device, Loop_opts, Feloop_fig);
Loops.period = 1/freq;
Loops.amp = amp;
Loops.init_pulse = 0;
Loops.version = "V01.01.00";


file_name = [num2str(i, '%04u') '.mat'];
file_addr = [output_folder '/' file_name];
save(file_addr, 'Loops')




