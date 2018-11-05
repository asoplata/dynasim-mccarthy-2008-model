%RUNMM08MODEL - Run the DynaSim implementation of the (McCarthy et al., 2008) model!
%{
This is a starter script to show both how to use the DynaSim mechanisms for
simulating the (McCarthy et al., 2008) model in Dynasim, available here
(https://github.com/asoplata/dynasim-mccarthy-2008-model) while also giving you
a good skeleton to start experimenting yourself.

- Install:
  1. Install DynaSim (https://github.com/DynaSim/DynaSim/wiki/Installation),
     including adding it to your MATLAB path.
  2. `git clone` or download this code's repo
     (https://github.com/asoplata/dynasim-mccarthy-2008-model) into
     '/your/path/to/dynasim/models', i.e. the 'models' subdirectory of your
     copy of the DynaSim repo.
  3. Run this file.
  4. Believe it or not...that should be it! You should be able to start MATLAB
     in your DynaSim code directory and run this script successfully!  Let me
     know if there are problems, at austin.soplata 'at-symbol-thingy' gmail
     'dot' com

- Dependencies:
    - This has only been tested on MATLAB version 2017a.

- References:
    - McCarthy, M. M., Brown, E. N., & Kopell, N. (2008). Potential Network
    Mechanisms Mediating Electroencephalographic Beta Rhythm Changes during
    Propofol-Induced Paradoxical Excitation. The Journal of Neuroscience: The
    Official Journal of the Society for Neuroscience, 28(50), 13488–13504.
    https://doi.org/10.1523/JNEUROSCI.3536-08.2008

This is descended from DynaSim's `tutorial.m` script, at
https://github.com/DynaSim/DynaSim/blob/master/demos/tutorial.m

Author: Austin E. Soplata <austin.soplata@gmail.com>
Copyright (C) 2018 Austin E. Soplata, Boston University, USA
%}

% -------------------------------------------------------------------
%% 1. Define simulation parameters
% -------------------------------------------------------------------
% Setting `study_dir` to `mfilename`, which is a reserved word, will
% automatically run the simulation and deposit its data and metadata into a
% new folder in the current directory that has the SAME NAME as this file:
study_dir = mfilename;
% If you're on a cluster and instead want to save the simulation results to a
% folder in a different location, use the commented-out line below instead:
% study_dir = strcat('/projectnb/$PROJECT/$USERNAME/p25-anesthesia-grant-sim-data/', mfilename);

% Debug: If you want to completely clean the environment, close all figures,
% and remove all data before running the simulation, set `debug` to 1:
debug = 0;
if debug == 1
    clf
    close all
    % Note: the below may be dangerous!
    if 7==exist(study_dir, 'dir')
        rmdir(study_dir, 's')
    end
end

% This is where you set the length of your simulation, in ms
time_end = 5000; % in milliseconds

% While DynaSim uses a default `dt` of 0.01 ms, we must specify ours explicitly
% since `dt` is actually used to construct our model directly.
dt = 0.05; % in milliseconds

% For the full size model (200 E's, 10 FS's, and 10 LTS's), use a
% `numCellsScaleFactor` of 1. To lower the number of cells simulated, but
% keep the same proportions, decrease this number to something > 0. As an
% example, using a numCellsScaleFactor of 0.1 (aka using a size of 10%)
% would decrease the population sizes to 20 E's, 1 FS, and 1 LTS.
numCellsScaleFactor = 1;

% "Vary" parameters, aka parameters to be varied -- this tells DynaSim to run a
% simulation for all combinations of values. For a tutorial on how to use
% this, see
% https://github.com/DynaSim/DynaSim/wiki/DynaSim-Getting-Started-Tutorial#running-sets-of-simulations-by-varying-model-parameters
% You can also type 'help Vary2Modifications' or see demos for more
% examples/instructions.
vary={
    'E','amp',[0.05];                % set AR(2) amp
    '(E->FS,E->LTS)','gAMPA',[0.7];  % set gei
};

% Here is where we set simulator options specific to `dsSimulate`, which are
% explained in the DynaSim code file `dsSimulate.m`.
simulator_options={
    'tspan', [0 time_end],...   % Time vector of simulation, [beg end], in milliseconds
    'dt', 0.05,...              % Fixed time step, in milliseconds
    'downsample_factor', 10,... % How much to downsample data, proportionally {integer}
    'study_dir', study_dir,...  % Where to save simulation results and code
    'solver', 'rk4',...         % Numerical integration method {'euler','rk1','rk2','rk4'}
    'save_data_flag', 0,...     % Whether to save raw output data, 0 or 1
    'save_results_flag', 1,...  % Whether to save output plots and analyses, 0 or 1
    'compile_flag', 0,...       % Whether to compile simulation using MEX, 0 or 1
    'cluster_flag', 0,...       % Whether to submit simulation jobs to a cluster, 0 or 1
    'verbose_flag', 1,...       % Whether to display process info, 0 or 1
    'overwrite_flag', 1,...     % Whether to overwrite simulation raw data, 0 or 1
    'random_seed', 'shuffle',...% What seed to use, or to randomize
    'parfor_flag', 0,...        % Whether to use parfor if running multiple local sims, 0 or 1
    'memory_limit', '8G',...    % Memory limit for use on cluster
    'num_cores', 1,...          % Number of CPU cores to use, including on cluster
    'plot_functions', {@dsPlot, @dsPlot, @dsPlot},...% Which plot functions to call
    'plot_options', {{'plot_type', 'waveform'},...   % Arguments to pass to each plot function
                     {'plot_type', 'rastergram'},...
                     {'plot_type', 'power'},...
                    },...
};


% -------------------------------------------------------------------------
%% 2. Assemble the model specification
% -------------------------------------------------------------------------
numCellsScaleFactor = 1;
spec = assembleMM08Spec(numCellsScaleFactor);

% -------------------------------------------------------------------------
%% 3. Run the simulation!
% -------------------------------------------------------------------------

data=dsSimulate(spec,'vary',vary,simulator_options{:});

% dsPlot(data);
% dsPlot(data,'plot_type','rastergram');
% dsPlot(data,'plot_type','power');

