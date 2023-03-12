




classdef Experiment < handle

methods(Access = public)
    function obj = Experiment(temp_start, temp_low, temp_step, freq_variant)
        disp('Experiment created:')
        [obj.temp_list, obj.freq_list] = ft_gen(temp_start, temp_low, temp_step, freq_variant);
    end
    
    function [temp, finish] = get_temp(obj)
        if obj.actual_temp_n > numel(obj.temp_list)
            temp = obj.temp_list(end);
            finish = 1;
        else
            temp = obj.temp_list(obj.actual_temp_n);
            obj.actual_temp_n = obj.actual_temp_n + 1;
            finish = 0;
        end
    end
    
    function [freq_list] = get_freq_list(obj)
        freq_list = obj.freq_list;
    end

end




properties(Access = private)
    temp_list = 295;
    freq_list = 1;

    actual_temp_n = 1;
end

end







