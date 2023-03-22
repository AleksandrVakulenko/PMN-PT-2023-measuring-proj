
FEloop_device = Ammeter('COM3', 'nyan', 'bias');
FEloop_device.connect();

voltage_gain = 270;
voltage_divider = 115.5;

i = 2;
period = 0.5;
amp = 450;

freq = 1/period;
Loop_opts = loop_options('amp', amp, ...
    'gain', voltage_gain, ...
    'divider', voltage_divider, ...
    'period', 1/freq, ...
    'delay', 0.3, ...
    'init_pulse', 0, ...
    'voltage_ch', 1);

Feloop_fig = figure;
hold on
cla
Loop(i).feloop = hysteresis_PE_DWM(FEloop_device, Loop_opts, Feloop_fig);
Loop(i).period = 1/freq;
Loop(i).amp = amp;
Loop(i).init_pulse = 0;
Loop(i).version = "V01.01.00";


FEloop_device.disconnect();

