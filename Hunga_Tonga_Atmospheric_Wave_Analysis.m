%% TTK19 Project: Hunga Tonga Atmospheric Wave Analysis
%
% This script generates all figures and numerical results used in the report.
%
% The script is based on the provided run_provided.m file. The supplied
% data-loading framework was retained, while the analysis, figure
% generation, filtering, convolution implementation, DTFT implementation,
% arrival picking workflow and celerity estimation were developed for the
% project tasks.
%
% Each task/subtask is clearly marked in the comments below.
%
% Task overview:
%   Task 1a : Station map
%   Task 1b : Closest and furthest stations
%   Task 1c : Sorted station distances
%   Task 2a : Impulse responses
%   Task 2b : Custom convolution implementation (my_conv)
%   Task 2c : Custom DTFT implementation and verification (my_dtft)
%   Task 2d : Filter frequency responses
%   Task 2f : Filtering all station records
%   Task 2g : Section plot
%   Task 3a-b : Arrival picks and celerity estimation

% --- Presumed location of the Tonga volcano
tonga_latlon = [-20.550, -175.385]; % latitude and longitude

% --- Data sources
% The following station files were supplied as part of the project dataset.
% Assumes the project data directory is the current working directory.
data_folder = pwd; 
fn_list = { ...
  'AM.R0033_unfilt.h5', ...
  'AM.R0318_unfilt.h5', ...
  'AM.R0352_unfilt.h5', ...
  'AM.R03EA_unfilt.h5', ...
  'AM.R06C4_unfilt.h5', ...
  'AM.R06CE_unfilt.h5', ...
  'AM.R0835_unfilt.h5', ...
  'AM.R08DA_unfilt.h5', ...
  'AM.R095E_unfilt.h5', ...
  'AM.R0C1F_unfilt.h5', ...
  'AM.R1033_unfilt.h5', ...
  'AM.R10D3_unfilt.h5', ...
  'AM.R10DB_unfilt.h5', ...
  'AM.R13D2_unfilt.h5', ...
  'AM.R160F_unfilt.h5', ...
  'AM.R167F_unfilt.h5', ...
  'AM.R176D_unfilt.h5', ...
  ['AM.R17FC_unfilt.h5' ...
''], ...
  'AM.R18EB_unfilt.h5', ...
  'AM.R1936_unfilt.h5', ...
  'AM.R199D_unfilt.h5', ...
  'AM.R216B_unfilt.h5', ...
  'AM.R25AC_unfilt.h5', ...
  'AM.R25D6_unfilt.h5', ...
  'AM.R266F_unfilt.h5', ...
  'AM.R2883_unfilt.h5', ...
  'AM.R2BFC_unfilt.h5', ...
  'AM.R2C45_unfilt.h5', ...
  'AM.R2D80_unfilt.h5', ...
  'AM.R2DDD_unfilt.h5', ...
  'AM.R2FF1_unfilt.h5', ...
  'AM.R3333_unfilt.h5', ...
  'AM.R3412_unfilt.h5', ...
  'AM.R347E_unfilt.h5', ...
  'AM.R3609_unfilt.h5', ...
  'AM.R3635_unfilt.h5', ...
  'AM.R3740_unfilt.h5', ...
  'AM.R3786_unfilt.h5', ...
  'AM.R3812_unfilt.h5', ...
  'AM.R39A8_unfilt.h5', ...
  'AM.R3A9B_unfilt.h5', ...
  'AM.R3F75_unfilt.h5', ...
  'AM.R40C1_unfilt.h5', ...
  'AM.R438F_unfilt.h5', ...
  'AM.R44DC_unfilt.h5', ...
  'AM.R45FA_unfilt.h5', ...
  'AM.R4649_unfilt.h5', ...
  'AM.R489A_unfilt.h5', ...
  'AM.R4A5A_unfilt.h5', ...
  'AM.R4B63_unfilt.h5', ...
  'AM.R4BA9_unfilt.h5', ...
  'AM.R4F67_unfilt.h5', ...
  'AM.R5419_unfilt.h5', ...
  'AM.R56C6_unfilt.h5', ...
  'AM.R571C_unfilt.h5', ...
  'AM.R5754_unfilt.h5', ...
  'AM.R5A2C_unfilt.h5', ...
  'AM.R5C9B_unfilt.h5', ...
  'AM.R6093_unfilt.h5', ...
  'AM.R63E7_unfilt.h5', ...
  'AM.R6936_unfilt.h5', ...
  'AM.R6BD0_unfilt.h5', ...
  'AM.R6CB0_unfilt.h5', ...
  'AM.R6F55_unfilt.h5', ...
  'AM.R7266_unfilt.h5', ...
  'AM.R75C2_unfilt.h5', ...
  'AM.R796B_unfilt.h5', ...
  'AM.R79F9_unfilt.h5', ...
  'AM.R7BC1_unfilt.h5', ...
  'AM.R7D02_unfilt.h5', ...
  'AM.R7D64_unfilt.h5', ...
  'AM.R834D_unfilt.h5', ...
  'AM.R85CD_unfilt.h5', ...
  'AM.R884B_unfilt.h5', ...
  'AM.R8866_unfilt.h5', ...
  'AM.R8A3D_unfilt.h5', ...
  'AM.R8AC9_unfilt.h5', ...
  'AM.R8CB3_unfilt.h5', ...
  'AM.R8D5C_unfilt.h5', ...
  'AM.R940D_unfilt.h5', ...
  'AM.R94AB_unfilt.h5', ...
  'AM.R94FB_unfilt.h5', ...
  'AM.R9606_unfilt.h5', ...
  'AM.R9767_unfilt.h5', ...
  'AM.R991C_unfilt.h5', ...
  'AM.R99EA_unfilt.h5', ...
  'AM.R9C27_unfilt.h5', ...
  'AM.R9CDF_unfilt.h5', ...
  'AM.R9D92_unfilt.h5', ...
  'AM.R9F0D_unfilt.h5', ...
  'AM.RA25D_unfilt.h5', ...
  'AM.RA461_unfilt.h5', ...
  'AM.RA48E_unfilt.h5', ...
  'AM.RA538_unfilt.h5', ...
  'AM.RA5CA_unfilt.h5', ...
  'AM.RA8D4_unfilt.h5', ...
  'AM.RAEE3_unfilt.h5', ...
  'AM.RAF39_unfilt.h5', ...
  'AM.RAFE2_unfilt.h5', ...
  'AM.RB3C2_unfilt.h5', ...
  'AM.RB46B_unfilt.h5', ...
  'AM.RB5CE_unfilt.h5', ...
  'AM.RB6FC_unfilt.h5', ...
  'AM.RB83C_unfilt.h5', ...
  'AM.RBE98_unfilt.h5', ...
  'AM.RBED8_unfilt.h5', ...
  'AM.RC170_unfilt.h5', ...
  'AM.RC1DA_unfilt.h5', ...
  'AM.RC4FB_unfilt.h5', ...
  'AM.RC59E_unfilt.h5', ...
  'AM.RC662_unfilt.h5', ...
  'AM.RC865_unfilt.h5', ...
  'AM.RC93C_unfilt.h5', ...
  'AM.RCB56_unfilt.h5', ...
  'AM.RCC6E_unfilt.h5', ...
  'AM.RCD03_unfilt.h5', ...
  'AM.RCDB6_unfilt.h5', ...
  'AM.RD120_unfilt.h5', ...
  'AM.RD2F0_unfilt.h5', ...
  'AM.RD44E_unfilt.h5', ...
  'AM.RD59C_unfilt.h5', ...
  'AM.RD617_unfilt.h5', ...
  'AM.RD7C1_unfilt.h5', ...
  'AM.RD8B4_unfilt.h5', ...
  'AM.RDACF_unfilt.h5', ...
  'AM.RDF00_unfilt.h5', ...
  'AM.RE1B7_unfilt.h5', ...
  'AM.RE582_unfilt.h5', ...
  'AM.RE991_unfilt.h5', ...
  'AM.REAF3_unfilt.h5', ...
  'AM.REB60_unfilt.h5', ...
  'AM.REDDF_unfilt.h5', ...
  'AM.RF082_unfilt.h5', ...
  'AM.RF2BA_unfilt.h5', ...
  'AM.RF356_unfilt.h5', ...
  'AM.RF3D1_unfilt.h5', ...
  'AM.RFCA1_unfilt.h5', ...
  'AM.S3774_unfilt.h5', ...
  'AM.S6197_unfilt.h5', ...
  'AM.S89A5_unfilt.h5', ...
  'AV.ADKI_unfilt.h5', ...
  'AV.AMKA_unfilt.h5', ...
  'AV.CLES1_unfilt.h5', ...
  'AV.DLL_unfilt.h5', ...
  'AV.KENI_unfilt.h5', ...
  'AV.SDPI_unfilt.h5', ...
  'AV.WHTR_unfilt.h5', ...
  'CC.GUAC_unfilt.h5', ...
  'GR.I26H1_unfilt.h5', ...
  'GR.I26H2_unfilt.h5', ...
  'GR.I26H3_unfilt.h5', ...
  'GR.I26H4_unfilt.h5', ...
  'GR.I26H5_unfilt.h5', ...
  'GR.I26H6_unfilt.h5', ...
  'GR.I26H7_unfilt.h5', ...
  'GR.I26H8_unfilt.h5', ...
  'GR.IGAH1_unfilt.h5', ...
  'GR.IGAH4_unfilt.h5', ...
  'GS.VEA1_unfilt.h5', ...
  'HV.WALE_unfilt.h5', ...
  'IU.ANMO_unfilt.h5', ...
  'NL.CIA06_unfilt.h5', ...
  'NL.CIA07_unfilt.h5', ...
  'NL.DBN01_unfilt.h5', ...
  'NL.DBN02_unfilt.h5', ...
  'NL.DBN03_unfilt.h5', ...
  'NL.DBN04_unfilt.h5', ...
  'NL.DBN05_unfilt.h5', ...
  'NL.DBN06_unfilt.h5', ...
  'NL.DL01_unfilt.h5', ...
  'NL.DL14_unfilt.h5', ...
  'NL.DL17_unfilt.h5', ...
  'NL.EXL01_unfilt.h5', ...
  'NL.EXL02_unfilt.h5', ...
  'NL.EXL03_unfilt.h5', ...
  'NL.EXL04_unfilt.h5', ...
  'NL.EXL06_unfilt.h5', ...
  'NL.L206_unfilt.h5', ...
  'NL.L208_unfilt.h5', ...
  'NL.L406_unfilt.h5', ...
  'NL.L509_unfilt.h5', ...
  'NZ.COVZ_unfilt.h5', ...
  'NZ.ETVZ_unfilt.h5', ...
  'NZ.FWVZ_unfilt.h5', ...
  'NZ.IVVZ_unfilt.h5', ...
  'NZ.KHEZ_unfilt.h5', ...
  'NZ.KRVZ_unfilt.h5', ...
  'NZ.MAVZ_unfilt.h5', ...
  'NZ.NEZ_unfilt.h5', ...
  'NZ.NGZ_unfilt.h5', ...
  'NZ.NOVZ_unfilt.h5', ...
  'NZ.NTVZ_unfilt.h5', ...
  'NZ.OTVZ_unfilt.h5', ...
  'NZ.PREZ_unfilt.h5', ...
  'NZ.SNVZ_unfilt.h5', ...
  'NZ.TMVZ_unfilt.h5', ...
  'NZ.TOVZ_unfilt.h5', ...
  'NZ.TRVZ_unfilt.h5', ...
  'NZ.WNVZ_unfilt.h5', ...
  'NZ.WTVZ_unfilt.h5', ...
  'OV.VRBA_unfilt.h5'};


N_files = length(fn_list);
export_folder = fullfile(data_folder, 'exported_figures');
if ~exist(export_folder, 'dir')
    mkdir(export_folder);
end
export_formats = {'svg', 'pdf'}; 


% --- Initialize
lats = zeros(N_files, 1);
lons = zeros(N_files, 1);
dt = zeros(N_files, 1);
my_labels = cell(N_files, 1);

data_collection = cell(N_files,1); % all station data
times_collection = cell(N_files,1); % all corresponding time vectors

D = zeros(N_files, 1); % distance from Tonga to each station, in meters
R_earth = 6371000; % mean Earth radius in meters (replaces wgs84Ellipsoid)

% --- Loop over all files and setup a matrix with
%     time and data as columns
for ii = 1:N_files

   disp(['Loading station ' num2str(ii) ' out of ' num2str(N_files)]);

   this_fn = fullfile(data_folder, fn_list{ii}); % The file path we will read
   info = h5info(this_fn);

   % h5disp(this_fn); % Uncomment this if you want to display a quick look at the file contents

   % Read the data from the first group and the first dataset of the group
   group_string = info.Groups(1).Name;
   dataset_string = info.Groups(1).Datasets(1).Name;

   % Read the latitude and longitude attributes for the station and put into vectors
   lats(ii) = h5readatt(this_fn, '/', 'latitude');
   lons(ii) = h5readatt(this_fn, '/', 'longitude');

   % Read the sensor recording
   data = h5read(this_fn, [group_string '/' dataset_string]);
   data_collection{ii} = data; % put the data of the current station into a cell array (which will contain all stations' data)
   N_samples = length(data);

   % Figure out the start time and generate a time vector
   starttime_str = h5readatt(this_fn, [group_string '/' dataset_string], 'starttime');
   starttime = datetime(starttime_str, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSSSS''Z'''); % convert the timestamp to a Matlab datetime object
   dt(ii) = h5readatt(this_fn, [group_string '/' dataset_string], 'delta'); % in seconds
   deltas = seconds(linspace(0, dt(ii)*(N_samples-1), N_samples)).'; % a duration which can be added to a datetime object
   times = starttime + deltas; % our time vector in datetime format
   times_collection{ii,1} = times; % put the times for this station into a common cell array (which will contain all stations' data)

   % Calculate the great circle distance from this station to the Tonga event
   D(ii) = haversine_distance(tonga_latlon(1), tonga_latlon(2), lats(ii), lons(ii), R_earth);

  

end % ii
                % At this point, for every station ii = 1..N_files we now have:
                %   lats(ii), lons(ii)        - its location
                %   data_collection{ii}       - its full waveform
                %   times_collection{ii}      - its full timestamp vector
                %   D(ii)                     - its distance from the volcano


% Verify that all stations share the same sampling interval.
unique(dt)
fs = 1/dt(1);


% --- Plot settings
lw_line = 3;
lw_volcano = 2;
lw_station = 1;
mz_station = 10; % marker size
my_lightgray = [1 1 1]*.9;

textColor = [0.1 0.1 0.1];

% --- Project station coordinates onto a plane centered on the volcano
% (azimuthal equidistant projection: distance from origin = true great-circle
% distance from Tonga, direction from origin = true bearing from Tonga)
[x_stations, y_stations] = azeq_project(tonga_latlon(1), tonga_latlon(2), lats, lons, R_earth);

%% Task 1a: Station map in azimuthal equidistant projection
%
% Project all station locations onto a plane centred on the Tonga volcano
% using an azimuthal equidistant projection. Distances and azimuths from
% Tonga are preserved in the projected coordinates.
fh = figure('position', [99 260 803 479],'color', 'w', 'defaultaxesfontsize', 10, 'defaultTextInterpreter', 'latex', 'defaultaxeslinewidth', 1.5, 'defaultlinelinewidth', lw_line, 'defaultaxestickdir', 'out', 'defaultAxesTickDirMode', 'manual', 'defaultaxesticklength', [0.003 0.003], 'defaultaxesTickLabelInterpreter', 'latex');

hold on
axis equal
axis off

plot(0, 0, 'x', 'Color', '#F20CAE', 'MarkerSize', 20, 'LineWidth', lw_volcano); % volcano at the origin
plot(x_stations, y_stations, '^', 'MarkerSize', mz_station, 'LineStyle', 'none', 'Color', '#D58FE3', 'LineWidth', lw_station); % stations

%% Task 1b: Identify closest and furthest stations
%
% Determine which stations have the smallest and largest great-circle
% distance from Tonga and highlight them in the station map.
[D_min, idx_min] = min(D);
[D_max, idx_max] = max(D);
fprintf('Shortest distance: %.1f km (station %s)\n', D_min / 1000, fn_list{idx_min});
fprintf('Longest distance:  %.1f km (station %s)\n', D_max / 1000, fn_list{idx_max});

% --- Highlight the shortest and longest distance stations ---
plot(x_stations(idx_min), y_stations(idx_min), 'o', 'MarkerSize', 14, 'LineWidth', 2, 'Color', '#6267DE'); % shortest
plot(x_stations(idx_max), y_stations(idx_max), 's', 'MarkerSize', 14, 'LineWidth', 2, 'Color', '#629CDE'); % longest

title('Station locations relative to Tonga volcano (azimuthal equidistant)', ...
      'Interpreter', 'latex', 'Color', textColor);
legend({'Tonga volcano', 'Stations', ...
        sprintf('Shortest (%.1f km)', D_min/1000), ...
        sprintf('Longest (%.1f km)', D_max/1000)}, ...
       'Location', 'bestoutside', 'TextColor', textColor, ...
       'Color', 'w', 'EdgeColor', [0.7 0.7 0.7]);

% Figure 1: Station map (Task 1a-1b)
exportVectorFigure(fh, export_folder, 'figure1_station_map', export_formats);

%% Task 1c: Sorted station distances
%
% Plot all station distances from Tonga after sorting from nearest to
% furthest station.

D_sorted = sort(D);
lineColor = '#D95319';   % change this to recolor the line and markers
textColor = [0.1 0.1 0.1];

fig = figure('Color', 'w');
plot(D_sorted / 1000, 'o-', ...
    'Color', lineColor, ...
    'MarkerFaceColor', lineColor, ...
    'MarkerEdgeColor', 'none', ...
    'MarkerSize', 4, ...
    'LineWidth', 1.5);

ax = gca;
set(ax, 'Color', 'w', ...
        'XColor', textColor, 'YColor', textColor, ...   % axis lines, ticks, tick labels
        'GridColor', [0.3 0.3 0.3], 'GridAlpha', 0.25, ...
        'FontSize', 11, 'Box', 'on');

xlabel('Station rank (sorted by distance)', 'FontSize', 12, 'Color', textColor);
ylabel('Distance from Tonga (km)', 'FontSize', 12, 'Color', textColor);
title('Sorted great-circle distances from Tonga to stations', ...
      'FontSize', 13, 'Color', textColor);

grid on;
xlim([0 length(D_sorted)+1]);
% Figure 2: Sorted station distances (Task 1c)
exportVectorFigure(fig, export_folder, 'figure2_sorted_distances', export_formats);



%% Filter definitions
%
% The assignment provides three FIR filters:
%   h1 : low-pass filter
%   h2 : band-pass filter
%   h3 : high-pass filter
h1 = [9.3102e-04
  -1.2991e-18
  -1.1771e-03
  -8.9350e-04
   1.1279e-03
   2.3259e-03
  -3.0497e-18
  -3.7419e-03
  -2.8954e-03
   3.5886e-03
   7.1273e-03
  -6.7002e-18
  -1.0473e-02
  -7.7679e-03
   9.2793e-03
   1.7882e-02
  -1.0958e-17
  -2.5342e-02
  -1.8731e-02
   2.2575e-02
   4.4596e-02
  -1.4316e-17
  -7.1659e-02
  -6.0472e-02
   9.2253e-02
   3.0157e-01
   3.9980e-01
   3.0157e-01
   9.2253e-02
  -6.0472e-02
  -7.1659e-02
  -1.4316e-17
   4.4596e-02
   2.2575e-02
  -1.8731e-02
  -2.5342e-02
  -1.0958e-17
   1.7882e-02
   9.2793e-03
  -7.7679e-03
  -1.0473e-02
  -6.7002e-18
   7.1273e-03
   3.5886e-03
  -2.8954e-03
  -3.7419e-03
  -3.0497e-18
   2.3259e-03
   1.1279e-03
  -8.9350e-04
  -1.1771e-03
  -1.2991e-18
   9.3102e-04];

h2 = [6.8867e-04
  -1.0409e-18
  -8.7071e-04
  -1.6144e-04
   2.4454e-03
   4.3979e-03
   2.9653e-03
   1.8510e-04
   1.9464e-03
   9.1274e-03
   1.2922e-02
   5.3683e-03
  -6.4293e-03
  -6.1213e-03
   7.3124e-03
   1.0978e-02
  -1.3170e-02
  -4.5946e-02
  -4.7642e-02
  -1.5176e-02
  -2.2060e-03
  -5.5677e-02
  -1.3549e-01
  -1.3111e-01
   1.6668e-02
   2.2307e-01
   3.2035e-01
   2.2307e-01
   1.6668e-02
  -1.3111e-01
  -1.3549e-01
  -5.5677e-02
  -2.2060e-03
  -1.5176e-02
  -4.7642e-02
  -4.5946e-02
  -1.3170e-02
   1.0978e-02
   7.3124e-03
  -6.1213e-03
  -6.4293e-03
   5.3683e-03
   1.2922e-02
   9.1274e-03
   1.9464e-03
   1.8510e-04
   2.9653e-03
   4.3979e-03
   2.4454e-03
  -1.6144e-04
  -8.7071e-04
  -1.0409e-18
   6.8867e-04];

h3 = [-2.4366e-04
  -2.6135e-19
   3.0807e-04
   7.3294e-04
   1.3147e-03
   2.0667e-03
   2.9630e-03
   3.9300e-03
   4.8428e-03
   5.5289e-03
   5.7792e-03
   5.3643e-03
   4.0571e-03
   1.6578e-03
  -1.9803e-03
  -6.9275e-03
  -1.3160e-02
  -2.0549e-02
  -2.8859e-02
  -3.7759e-02
  -4.6838e-02
  -5.5636e-02
  -6.3672e-02
  -7.0487e-02
  -7.5676e-02
  -7.8923e-02
   9.2033e-01
  -7.8923e-02
  -7.5676e-02
  -7.0487e-02
  -6.3672e-02
  -5.5636e-02
  -4.6838e-02
  -3.7759e-02
  -2.8859e-02
  -2.0549e-02
  -1.3160e-02
  -6.9275e-03
  -1.9803e-03
   1.6578e-03
   4.0571e-03
   5.3643e-03
   5.7792e-03
   5.5289e-03
   4.8428e-03
   3.9300e-03
   2.9630e-03
   2.0667e-03
   1.3147e-03
   7.3294e-04
   3.0807e-04
  -2.6135e-19
  -2.4366e-04];


%% Task 2a: Plot impulse responses
%
% Visualize the three provided FIR impulse responses in the discrete-time
% domain.
textColor = [0.1 0.1 0.1];
lineColor = '#DE3163'; 

hs     = {h1, h2, h3};
labels = {'h_1', 'h_2', 'h_3'};

fig3 = figure('Color', 'w');
for k = 1:3
    subplot(3,1,k);
    h = hs{k};
    n = 0:length(h)-1;

    stem(n, h, ...
        'Color', lineColor, ...
        'MarkerFaceColor', lineColor, ...
        'MarkerEdgeColor', lineColor, ...
        'MarkerSize', 4, ...
        'LineWidth', 1.2);

    set(gca, 'Color', 'w', ...
             'XColor', textColor, 'YColor', textColor, ...
             'GridColor', [0.3 0.3 0.3], 'GridAlpha', 0.25, ...
             'FontSize', 11, 'Box', 'on');
    grid on;

    xlabel('n', 'Interpreter', 'latex', 'FontSize', 12, 'Color', textColor);
    ylabel(['$' labels{k} '[n]$'], 'Interpreter', 'latex', ...
           'FontSize', 12, 'Color', textColor);
    title(['Impulse response $' labels{k} '[n]$'], 'Interpreter', 'latex', ...
          'FontSize', 13, 'Color', textColor);
end
% Figure 3: Impulse responses of h1, h2 and h3 (Task 2a)
exportVectorFigure(fig3, export_folder, 'figure3_impulse_responses', export_formats);


%% Task 2b Verification
%
% Compare outputs from my_conv() against MATLAB's conv() using a simple
% test signal and filter.
x_test = [1,2,3,4,5,6];   % pick a short toy signal, e.g. a few numbers
h_test = [1 0 -1];   % pick a short toy filter

% Full convolution comparison
y_mine_full = my_conv(x_test, h_test, 1);
y_matlab_full = conv(x_test, h_test);   % built-in, default = full length

% "Same" length comparison
y_mine_same = my_conv(x_test, h_test, 0);
y_matlab_same = conv(x_test, h_test, 'same');   % built-in, 'same' shape

% --- Compare ---
disp('Full convolution comparison:');
disp([y_mine_full, y_matlab_full(:)]);   % side-by-side

disp('Same-length convolution comparison:');
disp([y_mine_same, y_matlab_same(:)]);

fprintf('Max abs difference (full): %e\n', max(abs(y_mine_full - y_matlab_full(:))));
fprintf('Max abs difference (same): %e\n', max(abs(y_mine_same - y_matlab_same(:))));

%% Task 2c: Verification of DTFT implementation
%
% Compare the magnitude response produced by my_dtft() to MATLAB's freqz().

fs_test = 100;   % sample rate for testing (Hz)
N_test = 512;
[H_mine, f_mine] = my_dtft(h1, N_test, fs_test);
[H_builtin, f_builtin] = freqz(h1, 1, N_test, fs_test);

textColor = [0.1 0.1 0.1];
color1 = '#28a99e';   % my_dtft
color2 = '#DE3163';   % freqz

fig4 = figure('Color', 'w');
plot(f_mine, abs(H_mine), 'Color', color1, 'LineWidth', 2); hold on;
plot(f_builtin, abs(H_builtin), '--', 'Color', color2, 'LineWidth', 2);

ax = gca;
set(ax, 'Color', 'w', ...
        'XColor', textColor, 'YColor', textColor, ...
        'GridColor', [0.3 0.3 0.3], 'GridAlpha', 0.25, ...
        'FontSize', 11, 'Box', 'on');
grid on;

legend('my\_dtft', 'freqz', 'TextColor', textColor, ...
       'Color', 'w', 'EdgeColor', [0.7 0.7 0.7]);
xlabel('Frequency (Hz)', 'FontSize', 12, 'Color', textColor);
ylabel('|H|', 'FontSize', 12, 'Color', textColor);
title('Verification: my\_dtft vs freqz', 'FontSize', 13, 'Color', textColor);
% Figure 4: Verification of custom DTFT against MATLAB freqz (Task 2c)
exportVectorFigure(fig4, export_folder, 'figure4_dtft_vs_freqz', export_formats);



%% Task 2d: Magnitude spectra of the filters
%
% Compute and plot the magnitude frequency responses of h1, h2 and h3.
N_fft = 1024;   % number of frequency points (adjust for finer resolution)
[H1, f1] = my_dtft(h1, N_fft, fs);
[H2, f2] = my_dtft(h2, N_fft, fs);
[H3, f3] = my_dtft(h3, N_fft, fs);

textColor = [0.1 0.1 0.1];
lineColor = '#DE3163';   % change this to recolor all three curves

fs_f   = {f1, f2, f3};
Hs     = {H1, H2, H3};
labels = {'H_1', 'H_2', 'H_3'};
hnames = {'h_1', 'h_2', 'h_3'};

fig5 = figure('Color', 'w');
for k = 1:3
    subplot(3,1,k);
    plot(fs_f{k}, abs(Hs{k}), 'Color', lineColor, 'LineWidth', 1.5);

    set(gca, 'Color', 'w', ...
             'XColor', textColor, 'YColor', textColor, ...
             'GridColor', [0.3 0.3 0.3], 'GridAlpha', 0.25, ...
             'FontSize', 11, 'Box', 'on');
    grid on;

    xlabel('Frequency (Hz)', 'Interpreter', 'latex', ...
           'FontSize', 12, 'Color', textColor);
    ylabel(['$|' labels{k} '(e^{j\omega})|$'], 'Interpreter', 'latex', ...
           'FontSize', 12, 'Color', textColor);
    title(['Magnitude spectrum of $' hnames{k} '[n]$'], 'Interpreter', 'latex', ...
          'FontSize', 13, 'Color', textColor);
end
% Figure 5: Magnitude spectra of h1, h2 and h3 (Task 2d)
exportVectorFigure(fig5, export_folder, 'figure5_magnitude_spectra', export_formats);



%% Task 2f: Filter all station recordings
%
% Apply all three filters to each waveform using convolution.

filt1_collection = cell(N_files, 1);
filt2_collection = cell(N_files, 1);
filt3_collection = cell(N_files, 1);

for ii = 1:N_files

    disp(['Filtering station ' num2str(ii) ' out of ' num2str(N_files)]);

    x = data_collection{ii};

    filt1_collection{ii} = conv(x, h1, 'same');
    filt2_collection{ii} = conv(x, h2, 'same');
    filt3_collection{ii} = conv(x, h3, 'same');

end


%% Task 2g: Section plot
%
% Visualize filtered recordings as a function of distance from Tonga in
% order to identify propagating atmospheric arrivals.

textColor = [0.1 0.1 0.1];
scale = 5;   % controls how tall each wiggle appears

fig6 = figure('Color', 'w');
hold on;
for ii = 1:N_files
    trace = filt2_collection{ii};
    t = times_collection{ii};
    trace_norm = trace / rms(trace);   % normalize amplitude
    plot(t, trace_norm*scale + D(ii)/1000, 'Color', [0.1 0.1 0.1], 'LineWidth', 0.5);
end

set(gca, 'Color', 'w', ...
         'XColor', textColor, 'YColor', textColor, ...
         'GridColor', [0.3 0.3 0.3], 'GridAlpha', 0.25, ...
         'FontSize', 11, 'Box', 'on');

xlim([datetime(2022,1,15,0,0,0), datetime(2022,1,16,0,0,0)]);
xlabel('Time', 'FontSize', 12, 'Color', textColor);
ylabel('Distance from Tonga (km)', 'FontSize', 12, 'Color', textColor);
title('Section plot, bandpass filtered (h_2, 0.01--2 Hz target)', ...
      'FontSize', 13, 'Color', textColor);
% Figure 6: Section plot of bandpass-filtered station recordings (Task 2g)
exportVectorFigure(fig6, export_folder, 'figure6_section_plot', export_formats);


%% Task 3a-3b: Celerity estimation
%
% Load previously picked arrival times and estimate propagation velocity
% (celerity) by fitting distance versus travel time.

target_ranks = [1 8 15 22 29 35 42 49 56 63 70 77 84 91 98 104 111 118 125 132 139 146 153 160 167 173 180 187 194 201];
save_fn_list = cell(length(target_ranks), 1);
for k = 1:length(target_ranks)
    save_fn_list{k} = sprintf('picks_rank%d.mat', target_ranks(k));
end
analyze_celerity(save_fn_list, export_folder, export_formats);

%% ================= Local functions =================
% (MATLAB scripts can have local functions at the end of the file since R2016b)

% Helper functions used throughout the project.
%
% haversine_distance : great-circle distance calculation
% azeq_project : azimuthal equidistant projection
% my_conv : custom convolution implementation
% my_dtft : custom DTFT implementation
% pick_arrivals : manual arrival picking tool
% analyze_celerity : celerity estimation from picks
% exportVectorFigure : export figures to PDF and SVG

function d = haversine_distance(lat1, lon1, lat2, lon2, R)
    phi1 = deg2rad(lat1); phi2 = deg2rad(lat2);
    dphi = deg2rad(lat2 - lat1);
    dlambda = deg2rad(lon2 - lon1);
    a = sin(dphi/2).^2 + cos(phi1).*cos(phi2).*sin(dlambda/2).^2;
    c = 2*atan2(sqrt(a), sqrt(1-a));
    d = R * c;
end

function [x, y] = azeq_project(lat0, lon0, lats, lons, R)
    % Azimuthal equidistant projection centered at (lat0, lon0).
    % lats, lons can be vectors (one point per station).
    phi0 = deg2rad(lat0); lam0 = deg2rad(lon0);
    phi = deg2rad(lats(:)); lam = deg2rad(lons(:));

    cos_c = sin(phi0).*sin(phi) + cos(phi0).*cos(phi).*cos(lam - lam0);
    cos_c = min(max(cos_c, -1), 1); % clamp for numerical safety
    c = acos(cos_c); % angular distance from center, in radians

    k = c ./ sin(c);
    k(c == 0) = 0; % avoid 0/0 right at the origin (station coincides with volcano)

    x = R * k .* cos(phi0) .* sin(lam - lam0);
    y = R * k .* (cos(phi).*sin(phi0) - sin(phi).*cos(phi0).*cos(lam - lam0));
end


%% Task 2b: Custom convolution function
%
% Implementation of discrete-time convolution without using MATLAB's built-
% in conv() function.
function y = my_conv(x, h, ylen_choice)
M = length(x);
N = length(h);

%the full convolution length
y_full = zeros(M + N -1, 1);

for n = 1:length(y_full)
    for k = 1:M
        if (n-k+1) >= 1 && (n-k+1) <= N
            y_full(n) = y_full(n) + x(k) * h(n-k+1);
        end
    end
end

if ylen_choice == 1
    y = y_full;
else
    start_idx = floor((N-1)/2) + 1;       
    y = y_full(start_idx : start_idx + M - 1);
end

end


%% Task 2c: Custom DTFT implementation
%
% Compute the discrete-time Fourier transform directly from its definition.
function [H, f] = my_dtft(h, N, fs)
    n = 0:length(h)-1;
    
    f = linspace(0, fs, N);
    omega = 2*pi*f/fs;
    
    H = zeros(1, N);
    for m = 1:N
        H(m) = sum(h(:).' .* exp(-1j * omega(m) * n));
    end
end

%% Auxiliary function: Interactive arrival picking
function pick_arrivals(D, times_collection, data_collection, filt1_collection, filt2_collection, filt3_collection, idx_start, idx_stop, save_fn)

[D_sorted, sort_idx] = sort(D);

n_pick = idx_stop - idx_start + 1;
pick_time_sec = nan(n_pick, 1);
pick_dist     = nan(n_pick, 1);
pick_station  = nan(n_pick, 1);

t_origin_offset = 885;
c_min = 180;
c_max = 340;
pad   = 900;

counter = 0;
for rank = idx_start:idx_stop
    counter = counter + 1;
    ii = sort_idx(rank);
    t = times_collection{ii};
    t_rel = seconds(t - t(1));

    t_expect_min = t_origin_offset + D(ii)/c_max - pad;
    t_expect_max = t_origin_offset + D(ii)/c_min + pad;
    t_expect_min = max(t_expect_min, 0);

    mask = (t_rel >= t_expect_min) & (t_rel <= t_expect_max);

    t_plot     = t_rel(mask);
    raw_plot   = data_collection{ii}(mask);
    filt1_plot = filt1_collection{ii}(mask);
    filt2_plot = filt2_collection{ii}(mask);
    filt3_plot = filt3_collection{ii}(mask);

    fh = figure('Color','w');

    subplot(4,1,1);
    plot(t_plot, raw_plot);
    title(sprintf('Rank %d, station idx %d, dist = %.0f km — raw', rank, ii, D(ii)/1000));

    subplot(4,1,2);
    plot(t_plot, filt1_plot);
    title('h_1 (lowpass)');

    subplot(4,1,3);
    plot(t_plot, filt2_plot);
    title('h_2 (bandpass)');

    subplot(4,1,4);
    plot(t_plot, filt3_plot);
    title('h_3 (highpass) — click the first onset here');
    xlabel('Seconds since start of trace');

    sgtitle('Click the first clear onset (thermospheric arrival, h_3 recommended)');

    ax_pick = subplot(4,1,4);   % <-- re-grab this axes explicitly
    axes(ax_pick);              % <-- make sure it's the "current axes" MATLAB will use
    try
        [x_pick, ~] = ginput(1);
    catch
        warning('Figure closed before pick for station %d (rank %d). Skipping.', ii, rank);
        pick_time_sec(counter) = NaN;
        pick_dist(counter)     = D(ii);
        pick_station(counter)  = ii;
        save(save_fn, 'pick_time_sec', 'pick_dist', 'pick_station');
        continue;
    end

    hold on;
    plot(x_pick, 0, 'r*', 'MarkerSize', 15);
    pause(0.3);

    pick_time_sec(counter) = x_pick;
    pick_dist(counter)     = D(ii);
    pick_station(counter)  = ii;

    travel_time = x_pick - t_origin_offset;
    if travel_time > 0
        implied_celerity = D(ii) / travel_time;
        fprintf('Rank %d (station %d): implied celerity = %.1f m/s', rank, ii, implied_celerity);
        if implied_celerity < 180 || implied_celerity > 340
            fprintf('  <-- WARNING: outside 180-340 m/s, check this pick!\n');
        else
            fprintf('\n');
        end
    else
        fprintf('Rank %d (station %d): WARNING — pick is before eruption origin time!\n', rank, ii);
    end

    if isvalid(fh)
        close(fh);
    end

    save(save_fn, 'pick_time_sec', 'pick_dist', 'pick_station');
end

end

%% Auxiliary function: Celerity estimation and plotting
function analyze_celerity(save_fn_list, exportFolder, exportFormats)

% --- Load and concatenate all picks from the given files ---
all_time = [];
all_dist = [];
all_station = [];

for k = 1:length(save_fn_list)
    S = load(save_fn_list{k});
    all_time = [all_time; S.pick_time_sec(:)];
    all_dist = [all_dist; S.pick_dist(:)];
    all_station = [all_station; S.pick_station(:)];
end

% --- Drop any skipped (NaN) picks ---
valid = ~isnan(all_time) & ~isnan(all_dist);
all_time = all_time(valid);
all_dist = all_dist(valid);
all_station = all_station(valid);

% --- Convert pick time to travel time (subtract eruption origin offset) ---
t_origin_offset = 885;   % seconds, matches pick_arrivals
travel_time = all_time - t_origin_offset;

% --- First-pass linear fit (least-squares line through all points) ---
p1 = polyfit(travel_time, all_dist, 1);
fit1 = polyval(p1, travel_time);
resid = all_dist - fit1;

% --- Flag outliers: more than 2 standard deviations from the first fit ---
resid_std = std(resid);
is_outlier = abs(resid) > 2 * resid_std;

% --- Refit using only the non-outlier points ---
p2 = polyfit(travel_time(~is_outlier), all_dist(~is_outlier), 1);
celerity = p2(1);   % m/s

fprintf('Number of picks total: %d\n', length(travel_time));
fprintf('Number flagged as outliers: %d\n', sum(is_outlier));
fprintf('Celerity estimate (from refit, excluding outliers): %.1f m/s\n', celerity);

% --- Plot ---
textColor = [0.1 0.1 0.1];
colUsed    = '#DE3163';
colOutlier = '#28a99e';

fig7 = figure('Color','w');
hold on;

plot(travel_time(~is_outlier), all_dist(~is_outlier)/1000, 'o', ...
     'Color', colUsed, 'MarkerFaceColor', colUsed, 'MarkerSize', 6);
plot(travel_time(is_outlier), all_dist(is_outlier)/1000, 'x', ...
     'Color', colOutlier, 'MarkerSize', 10, 'LineWidth', 2);

t_line = linspace(min(travel_time), max(travel_time), 100);
plot(t_line, polyval(p2, t_line)/1000, '-', 'Color', textColor, 'LineWidth', 1.5);

set(gca, 'Color', 'w', ...
         'XColor', textColor, 'YColor', textColor, ...
         'GridColor', [0.3 0.3 0.3], 'GridAlpha', 0.25, ...
         'FontSize', 11, 'Box', 'on');
grid on;

xlabel('Travel time (s)', 'FontSize', 12, 'Color', textColor);
ylabel('Distance from Tonga (km)', 'FontSize', 12, 'Color', textColor);
title(sprintf('Celerity estimate: %.1f m/s', celerity), ...
      'FontSize', 13, 'Color', textColor);
legend({'Picks (used)', 'Picks (outliers, excluded)', 'Linear fit'}, ...
       'Location', 'southeast', 'TextColor', textColor, ...
       'Color', 'w', 'EdgeColor', [0.7 0.7 0.7]);

% Figure 7: Celerity estimation from picked arrival times (Tasks 3a-3b)
exportVectorFigure(fig7, exportFolder, 'figure7_celerity', exportFormats);

end

%% Auxiliary function: Export figures to PDF and SVG
function exportVectorFigure(figHandle, exportFolder, baseName, exportFormats)
    for k = 1:numel(exportFormats)
        ext = exportFormats{k};
        exportgraphics(figHandle, fullfile(exportFolder, [baseName '.' ext]), ...
            'ContentType', 'vector');
    end
end

