
Fern.load('Dahlia')

% output_folder = create_folder('Output_2024_09_18_PZT_film');
% output_folder = create_folder('Output_2024_10_03_PZT_film');
% output_folder = create_folder('Output_2024_10_10_PZT_film');
% output_folder = create_folder('Output_2024_10_25_1_PZT_film');
% output_folder = create_folder('Output_2024_10_25_2_PZT_film');
% output_folder = create_folder('Output_2024_10_25_3_PZT_film');
% output_folder = create_folder('Output_2024_10_28_7_PZT_film');
% output_folder = create_folder('Output_2024_10_28_6_PZT_film');
% output_folder = create_folder('Output_2025_01_25_2_PZT_film');
output_folder = create_folder('Output_2025_01_27_1_PZT_film');
ii = 0;

%%
clc
Feloop_fig = figure;

FEloop_device = Dahlia('COM3');

% pauses_array_min = [10 10 10 10 10 10 10 10 ...
%                     20 20 20 20 20 20 20 ...
%                     40 40 40 ...
%                     60 60 60];

pauses_array_min = [0];

% pauses_array_min = 0;

Current_meas_period = 0;
loops_count = 5000;

for kk = 1:numel(pauses_array_min)
    for k = 1:loops_count
        Sample.h = 60e-9; % m
        Sample.d = 150e-6;
        Sample.s = pi*(Sample.d/2)^2; % m^2
        Sample.comment = "Au E20 / new ammeter";
        Sample.name = "PZT film 60nm";

        % settings
        voltage_gain = 1;
        voltage_divider = 1;
        

        % i = 1;
        ii = ii + 1;

        freq = 50/1;
        amp = 8.0;
        section_delay = 0.000;
        inverse = false;
        
        init_pulse = 1;
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
            'delay', section_delay, ...
            'refnum', 2, ...
            'init_pulse', init_pulse, ...
            'voltage_ch', 0);


        FEloop_device.Capacitor("150n");

        Loops.feloop = hysteresis_PE_DWM3(FEloop_device, Loop_opts, Feloop_fig, inverse);
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
    
    if (Current_meas_period > 0)
    %     FEloop_device.switch_feedback_res(0, 'low');
        [time_out, current_out] = current_measure(FEloop_device, Current_meas_period, Feloop_fig);
    
        Charge = trapz(time_out, current_out);
        Polar = (Charge*1e6)/(Sample.s*100*100);
        disp(['P = ' num2str(Polar, '%0.2f') ' uC/cm^2'])
        save([output_folder '/' 'current_' num2str(ii) '.mat'], 'time_out', 'current_out');
    end

    pause(60*pauses_array_min(kk));
end



FEloop_device.delete;




%%

folder = '../PMN-PT 2023 measuring/Output_2025_01_25_PZT_film';
replace_folder = false; %% don't use !!
delete_files = false;
result_files_union(folder, replace_folder, delete_files);




