
Fern.load("Dahlia")
addpath(genpath('.'));

% error('folder name')
output_folder = create_folder('Output_2026_03_11_PMN_55PSN');
Temp_num = 0;

%%
% error("sample spec")
Time_init = tic;

Temp = 299; % K

CAP_V = "150n"; % "20u" "150n"

clc
Feloop_fig = figure('position', [440  285  800  620]);
FEloop_device = Dahlia('COM3');
Temp_num = Temp_num + 1;

% Freq_arr = [50 20 10 5 2 1 50 20];
Freq_arr = [50 20 10 5 2 1 50 20 10 0.5 0.2 0.1 50 20 10];
% Amp_arr = [150 200 250];
Amp_arr = [360];
Refnum = 1;

% Freq_arr = [50 20 10 5 2 1 50 20 10 0.5 50 20 10];
% Amp_arr = [250];
% Refnum = 5;

[Freq_grid, Amp_grid] = meshgrid(Freq_arr, Amp_arr);

Loops = [];
loop_ind = 0;
for k = 1:numel(Amp_arr)
    for j = 1:numel(Freq_arr)
        Freq = Freq_grid(k, j);
        Amp = Amp_grid(k, j);
        disp([num2str(Freq, '%.2f') ' Hz | ' num2str(Amp) ' V'])
        
        Sample.h = 240e-6; % m
        Sample.d = 1.12e-3; % m
        Sample.s = pi*(Sample.d/2)^2; % m^2
        Sample.comment = string([num2str(Temp) 'K']);
        Sample.name = "PMN-55PSN";
        
        % settings
        Voltage_gain = 100;
        Voltage_divider = 100;
 
        Inverse = false;
        Init_pulse = 1;
        
        Loop_opts = loop_options('amp', Amp, ...
            'gain', Voltage_gain, ...
            'divider', Voltage_divider, ...
            'period', 1/Freq, ...
            'post', 0, ...
            'delay', 0.1, ...
            'refnum', Refnum, ...
            'init_pulse', Init_pulse, ...
            'voltage_ch', 0);
        
        
        FEloop_device.Capacitor(CAP_V);
        
        Feloop = hysteresis_PE_DWM3(FEloop_device, Loop_opts, ...
                                    Feloop_fig, Inverse);
        
        loop_ind = loop_ind + 1;
        Loops(loop_ind).feloop = Feloop;
        Loops(loop_ind).period = 1/Freq;
        Loops(loop_ind).amp = Amp;
        Loops(loop_ind).init_pulse = Loop_opts.init_pulse;
        Loops(loop_ind).version = "V01.01.00";
        Loops(loop_ind).sample = Sample;
        Loops(loop_ind).datetime = datetime;
        Loops(loop_ind).temp = Temp;
        
    end
end

file_name = [num2str(Temp_num, '%04u') '.mat'];
file_addr = [output_folder '/' file_name];
disp(file_addr)
disp(' ')
save(file_addr, 'Loops')



FEloop_device.delete;

Time_passed = toc(Time_init);
disp(['Time: ' num2str(Time_passed, '%0.1f')]);
do_sound(400, 0.7);

%%

folder = '../PMN-PT 2023 measuring/Output_2025_01_25_PZT_film';
replace_folder = false; %% don't use !!
delete_files = false;
result_files_union(folder, replace_folder, delete_files);




