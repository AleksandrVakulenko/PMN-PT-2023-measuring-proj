
addpath(genpath('../Ammeter class/'));
addpath(genpath('.'));

% output_folder = create_folder('Output_2024_09_18_PZT_film');
% output_folder = create_folder('Output_2024_10_03_PZT_film');
% output_folder = create_folder('Output_2024_10_10_PZT_film');
% output_folder = create_folder('Output_2025_01_25_PZT_film');
ii = 0;

%%
clc
Feloop_fig = figure;

FEloop_device = Ammeter('COM3', 'nyan', 'bias');

pauses_array_min = [10 10 10 10 10 10 10 10 ...
                    20 20 20 20 20 20 20 ...
                    40 40 40 ...
                    60 60 60];

loops_count = 1;

% for kk = 1:numel(pauses_array_min)
    for k = 1:loops_count
        Sample.h = 60e-9; % m
        Sample.d = 150e-6;
        Sample.s = pi*(Sample.d/2)^2; % m^2
        Sample.comment = "Ni E17";
        Sample.name = "PZT film 60nm";

        % settings
        voltage_gain = 1;
        voltage_divider = 1;



        % i = 1;
        ii = ii + 1;

        freq = 4/1;
        amp = 8;

        if ii == 1
            init_pulse = 1;
        else
            init_pulse = 0;
        end

        Loop_opts = loop_options('amp', amp, ...
            'gain', voltage_gain, ...
            'divider', voltage_divider, ...
            'period', 1/freq, ...
            'post', 0.0, ...
            'delay', 0.05, ...
            'refnum', 3, ...
            'init_pulse', init_pulse, ...
            'voltage_ch', 0);


        cla
        Loops.feloop = hysteresis_PE_DWM2(FEloop_device, Loop_opts, Feloop_fig);
        Loops.period = 1/freq;
        Loops.amp = amp;
        Loops.init_pulse = Loop_opts.init_pulse;
        Loops.version = "V01.01.00";
        Loops.sample = Sample;
        Loops.datetime = datetime;


        % output_folder = 'Output_2024_10_10_PZT_film'; % FIXME !!
        file_name = [num2str(ii, '%04u') '.mat'];
        file_addr = [output_folder '/' file_name];
        disp(file_addr)
        disp(' ')
        save(file_addr, 'Loops')

    end
%     pause(60*pauses_array_min(kk));
% end





%%

% folder = '../PMN-PT 2023 measuring/Output_2024_10_24_PZT_film';
% replace_folder = false;
% delete_files = false;
% result_files_union(folder, replace_folder, delete_files);