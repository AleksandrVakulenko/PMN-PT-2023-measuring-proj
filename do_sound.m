


function do_sound(freq, Period)
% freq = 500;
% Period = 1;

Fs = 44e3;


time = 0:1/Fs:Period;
signal = sin(2*pi*freq*time);

sound(signal, Fs)


end














