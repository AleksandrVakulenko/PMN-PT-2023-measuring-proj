
Fern.load('Dahlia')

output_folder = create_folder('Output_2025_10_20_1_ANTO_8');
ii = 0;

%%
clc
Feloop_fig = figure;

FEloop_device = Dahlia('COM4');


Current_meas_period = 0;
loops_count = 1;

for k = 1:loops_count
    Sample.h = 25e-6; % m
    Sample.d = 2*260e-6; % m
    Sample.s = pi*(Sample.d/2)^2; % m^2
    Sample.comment = "clown science";
    Sample.name = "ANTO cer 25 um try 8-9 D:";

    % settings
    voltage_gain = 100;
    voltage_divider = 100;
    

    % i = 1;
    ii = ii + 1;

    freq = 20/1;
    amp = 500.0;
    section_delay = 0.500;
    inverse = false;
    
    init_pulse = 0;
%     if ii == 1
%         init_pulse = 1;
%     else
%         init_pulse = 0;
%     end

    Loop_opts = loop_options('amp', amp, ...
        'gain', voltage_gain, ...
        'divider', voltage_divider, ...
        'period', 1/freq, ...
        'post', 0.0, ...
        'delay', section_delay, ...
        'refnum', 1, ...
        'init_pulse', init_pulse, ...
        'voltage_ch', 1);


%     FEloop_device.Capacitor("150n");
    FEloop_device.Capacitor("20u");
%     FEloop_device.switch_feedback_res(3, 'high');

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




FEloop_device.delete;






