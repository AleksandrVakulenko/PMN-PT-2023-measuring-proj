function output_folder_out = create_folder(output_folder)

    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    else
        nowday = char(datetime(now,'ConvertFrom','datenum'));
        nowday = strrep(nowday, ':', '_');
        nowday = strrep(nowday, ' ', '_');
        output_folder = ['Output_results_' char(nowday)];
        mkdir(output_folder);
    end

    output_folder_out = output_folder;
end