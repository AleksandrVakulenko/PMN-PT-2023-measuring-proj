
Fern.load("Dahlia")
addpath(genpath('.'));


output_folder = create_folder('Output_2025_12_03_NBBF1');
ii = 0;

%%
% error("qwq")

Temp = 250; % K

CAP_V = "20u"; % "20u"

Sample.h = 1e-3; % m
Sample.d = 8.6e-3; % m
Sample.s = pi*(Sample.d/2)^2; % m^2
Sample.comment = string([num2str(Temp) 'K']);
Sample.name = "NBBF1_para";

% settings
Voltage_gain = 1000;
Voltage_divider = 1000;




clc
Feloop_fig = figure('position', [440  285  800  620]);

FEloop_device = Dahlia('COM3');

% pauses_array_min = [10 10 10 10 10 10 10 10 ...
%                     20 20 20 20 20 20 20 ...
%                     40 40 40 ...
%                     60 60 60];


% Freq_array = [0.2 0.5 1 2 5 10 20 50];
Amp_array = [600, 800, 1000, 1200, 1300];


% for kk = 1:numel(pauses_array_min)
    
    Loops = [];
    for k = 1:numel(Amp_array)

        % i = 1;
        
        Freq = 1/10;
        Amp = Amp_array(k);
        Inverse = false;
        
        Init_pulse = 1;
%         if ii == 1
%             Init_pulse = 1;
%         else
%             Init_pulse = 0;
%         end

        Loop_opts = loop_options('amp', Amp, ...
            'gain', Voltage_gain, ...
            'divider', Voltage_divider, ...
            'period', 1/Freq, ...
            'post', 1, ...
            'delay', 1.0, ...
            'refnum', 2, ...
            'init_pulse', Init_pulse, ...
            'voltage_ch', 0);

        FEloop_device.Capacitor(CAP_V);

        Loops(k).feloop = hysteresis_PE_DWM3(FEloop_device, Loop_opts, Feloop_fig, Inverse);
        Loops(k).period = 1/Freq;
        Loops(k).amp = Amp;
        Loops(k).init_pulse = Loop_opts.init_pulse;
        Loops(k).version = "V01.01.00";
        Loops(k).sample = Sample;
        Loops(k).datetime = datetime;

    end

    ii = ii + 1;
    % output_folder = 'Output_2024_10_10_PZT_film'; % FIXME !!
    file_name = [num2str(ii, '%04u') '.mat'];
    file_addr = [output_folder '/' file_name];
    disp(file_addr)
    disp(' ')
    save(file_addr, 'Loops')
    
% end



FEloop_device.delete;




%%

folder = '../PMN-PT 2023 measuring/Output_2025_01_25_PZT_film';
replace_folder = false; %% don't use !!
delete_files = false;
result_files_union(folder, replace_folder, delete_files);




