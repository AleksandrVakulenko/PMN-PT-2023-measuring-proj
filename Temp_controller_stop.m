function Temp_controller_stop(Temp_ctrl_device)
    Temp_ctrl_device.set_ramp(false, 1); % turn off ramp
    Temp_ctrl_device.set_setpoint(295); % set room temp
    Temp_ctrl_device.set_heater_range(0); % turn on heater
end