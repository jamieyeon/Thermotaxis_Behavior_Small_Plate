% Run this script to filter out noise from tracks data.
% It sets the valuse of global parameters necessary for the analysis 
% and saves the filtered tr data structure in a file with the prefix 
% 'F_'

%Global parameters for filter_noise4.m: 
global Min_Dist_for_track      % in pixels - 6 pixels ~ worm body length
global Min_Time_for_track      % in seconds
global Min_RadiusOfGyration_for_Track  % in pixels - 6 pixels ~ worm body length
global Max_Dist_for_run        % in pixels - 6 pixels ~ worm body length
global Max_Time_for_run        % in seconds
global Min_Dist_for_run        % in pixels - 6 pixels ~ worm body length
global Min_Time_for_run        % in seconds
global Max_XY_for_single_frame % in pixels (normalized for per second value)
global Min_average_velocity    % pixels/second (about 0.25x of average velocity) 
global Max_average_velocity    % pixels/second (about 4x of average velocity)

newcam=2;

Min_Dist_for_track = 8*newcam; % in pixels - 6 pixels ~ worm body length
Min_Time_for_track = 5; % in seconds

Min_RadiusOfGyration_for_Track = 8*newcam; % in pixels - 6 pixels ~ worm body length
Max_Dist_for_run   = 600*newcam; % in pixels - 6 pixels ~ worm body length
Max_Time_for_run   = 600; % in seconds
Min_Dist_for_run   = 8*newcam; % in pixels - 6 pixels ~ worm body length
Min_Time_for_run   = 4; % in seconds


Min_average_velocity = 0.2*newcam; % pixels/second (average velocity: ~1 pixel/sec) 

Max_average_velocity = 5*newcam;   % pixels/second (average velocity: ~1 pixel/sec) 
Max_XY_for_single_frame = Max_average_velocity/FPS; % in pixels (normalized for per second value)

SAVE_FILTERED = 0; % set to 1 to save filtered tr structure
t0 = clock; 

basedir = 'Y:\David Test\z. data\';
% Only load tr from file if not in memory! 
if isempty(whos('tr')) % This means that tr is not in the memory and needs uploading
    display(['Error: ''tr'' structure not found. ']);
    display(['Please run ''Find_tracks_in_raw_data.m'' and then retry.']);
    return;
    %%% Older code designed to get tr from a mat file where it was %%%
    %%% saved. Newer code does not save tr (too big) but only a    %%% 
    %%% data-summary structure.                                    %%%  
    %[fn, pth] = uigetfile([basedir '*.mat'],'Select tracks data file:');
    %tmp1 = load([pth '\' fn]);       % should give a structure: tmp1.tr 
    %tmp2 = fieldnames(tmp1);         % should be only one field, called "tr"
    %tr = filter_noise4( tmp1.(cell2mat(tmp2(1))) );   % tmp1.tr contains the tracks data
    %clear('tmp1','tmp2');            % save memory, tmo1 and tr might be very large
else % tr is in memory already, just choose path
    %multiple_plates_meanT_over_time(tr);
   % title('BEFORE filtering out noise.');
    pth = tr(1).path;
    tmp1 = filter_noise4(tr);
    tr = tmp1;
    clear('tmp1');
end;

if SAVE_FILTERED
    save_tr4(pth,'F_',tr); % saves filtered tr structure
end;

%%% quick look at filtering results: 
%Plot_Tracks_and_turns(tr);
%multiple_plates_meanT_over_time(tr);
%title('AFTER filtering out noise.');
data_summary = make_data_summary4(tr);

%TO BE DELETED: Analyze_runs_and_turns; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%               PLOTS               %%%
%%% Comment out unwanted plots AND/OR %%%
%%% add new ploting functions here.   %%%
%%% (These are only examples - make   %%%
%%% new ones by copying and modifying %%%
%%% the code. Keep a copy of the      %%%
%%% original for reference.           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%make_plot_run_duration_vs_angle(data_summary);
%make_plot_run_distributions(data_summary);
%make_plot_run_distributions2(data_summary);
%make_plot_contribution_of_runs_to_Icr(data_summary);
%make_plot_IT_distribution(data_summary);
%make_plot_IT_distribution2(data_summary);
%make_plot_turns_in_time_bins(data_summary);
%make_plot_turns_in_time_bins2(data_summary);

display(['Run time: ' num2str(round(etime(clock,t0)/6)/10) ' minutes.']);  % time in minutes

