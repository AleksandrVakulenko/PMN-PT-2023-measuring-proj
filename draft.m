

addpath(genpath('../Ammeter class/'));
addpath(genpath('../Криостат 417/'));
addpath(genpath('../LCR Keysight matlab/'));


LCR_device = KeysightLCR();
FEloop_device = Ammeter('COM0', 'nyan', 'bias');
Temp_ctrl_device = Lakeshore325('COM0');
% TODO: set_room_temp()


FEloop_device.connect();
try
% ----- main part -------

    % set_temp()
    % get_loop()
    % save_results();

% ---- main part end ----
catch
    FEloop_device.disconnect();
    clearvars LCR_device Temp_ctrl_device FEloop_device
    disconnected = true;
end

if ~disconnected
    FEloop_device.disconnect();
    clearvars LCR_device Temp_ctrl_device FEloop_device
    disconnected = true;
end


% disconnect from feloop
% throw LCR
% return room temp to temp ctrt
% throw temp ctrl

