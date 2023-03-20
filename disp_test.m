

freq = 1;
amp = 10;

period_actual = 1/freq;

i = 3;
freq_list_size = 8;

temp_actual = 140;

temp_number = 2;

temp_list_size = 23;

disp(['    Period: ' num2str(period_actual) ' s |' ...
    ' Amp: ' num2str(amp) ' V (' ...
    num2str(i) '/' num2str(freq_list_size) ') |' ...
    ' Temp: ' num2str(temp_actual) ' K (' ...
    num2str(temp_number) '/' num2str(temp_list_size) ')']);



%%


temp_set_point = 295.1234;
k = 10;
temp_graph.temp(k) = 295.323424;
stable_value = 0.31231233;
temp_number = 1;
temp_list_size = 90;

disp(['Temp_sp: ' num2str(temp_set_point, '%0.2f') ' K ' ...
    'Temp: ' num2str(temp_graph.temp(k), '%0.2f') ' K ' ...
    'sv: ' num2str(stable_value, '%0.4f') ' ('...
    num2str(temp_number) '/' num2str(temp_list_size) ')'])

