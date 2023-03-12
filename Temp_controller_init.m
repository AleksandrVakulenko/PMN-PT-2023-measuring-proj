function Temp_controller_init(Temp_ctrl_device, exp_obj, ramp_rate)
    init_temp = exp_obj.get_init_temp();
    Temp_ctrl_device.set_ramp(false, ramp_rate); % turn off ramp
    Temp_ctrl_device.set_setpoint(init_temp); % set room temp
    Temp_ctrl_device.set_ramp(true, ramp_rate); % turn on ramp
    Temp_ctrl_device.set_heater_range(2); % turn on heater
end