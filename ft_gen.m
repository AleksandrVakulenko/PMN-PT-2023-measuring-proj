function [temp_list, freq_list] = ft_gen(temp_start, temp_low, temp_step, freq_variant)

switch freq_variant
    case "freq_full"
        freq_list = 1./[0.1 0.2 0.5 0.75 1 1.5 2 3 5 7.5 10 ...
                        12 15 17.5 25 35 45 60];

    case "freq_mid"
        freq_list = 1./[0.1 0.2 0.5 1 2 5 10 20 60];

    case "freq_fast"
        freq_list = 1./[0.1 0.2 0.5 0.75 1 1.5 2 3 5 7.5 10];

    otherwise
        freq_list = 1./[0.1 0.2 0.5 1 2 5 10];

end


% temp_start = 295; %K
% temp_low = 80; %K
temp_final = temp_start;
% temp_step = 5; %K

temp_fall = [temp_start:-temp_step:temp_low];
temp_rise = [temp_low+temp_step:temp_step:temp_final];
temp_list = [temp_fall temp_rise];


[temp_list, freq_list] = tf_list_check(temp_list, freq_list);

end