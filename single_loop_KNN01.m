
addpath(genpath('../Ammeter class/'));
addpath(genpath('.'));

% output_folder = create_folder('Output_2024_09_18_PZT_film');
output_folder = create_folder('Output_2024_10_10_KNN_100um');
i = 0;

%%
clc

Sample.h = 100e-6; % m
% Sample.s = 0.001*0.001; % m^2
Sample.D = 2e-3;
Sample.s = pi*(Sample.D/2)^2; % m^2

% settings
voltage_gain = 1000;
voltage_divider = 1000;


FEloop_device = Ammeter('COM3', 'nyan', 'bias');
% i = 1;
i = i + 1;

freq = 1/5;
amp = 800;

Loop_opts = loop_options('amp', amp, ...
    'gain', voltage_gain, ...
    'divider', voltage_divider, ...
    'period', 1/freq, ...
    'post', 3.05, ...
    'delay', 1.05, ...
    'refnum', 3, ...
    'init_pulse', 1, ...
    'voltage_ch', 1);

Feloop_fig = figure;
cla
Loops.feloop = hysteresis_PE_DWM(FEloop_device, Loop_opts, Feloop_fig);
Loops.period = 1/freq;
Loops.amp = amp;
Loops.init_pulse = Loop_opts.init_pulse;
Loops.version = "V01.01.00";
Loops.sample = Sample;

output_folder = 'Output_2024_10_10_KNN_100um'; % FIXME !!
file_name = [num2str(i, '%04u') '.mat'];
file_addr = [output_folder '/' file_name];
disp(file_addr)
save(file_addr, 'Loops')




