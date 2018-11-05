addpath(pwd); % add this directory to path to locate AR2()
% -------------------------------------------------------------------------
% simulation controls
tspan=[0 5000];  % [beg end], ms
dt=.05;         % fixed time step, ms
solver='rk4';   % numerical integration method {'rk1','rk2','rk4'}
% AES
% compile_flag=1; % whether to compile simulation
compile_flag=0; % whether to compile simulation
verbose_flag=1; % whether to display process info
downsample_factor=10; % how much to downsample the simulated data wrt 1/dt
save_data_flag=0;
study_dir=[];   % where to save data if save_data_flag is set to 1
cluster_flag=0; % whether to create and submit simulation jobs to cluster (eg, on SCC)
plot_functions=[]; plot_options=[]; % tip: use if cluster_flag=1: plot_functions={@PlotData,@PlotData}; plot_options={{'plot_type','rastergram'},{'plot_type','power'}};
simulator_options={'save_data_flag',save_data_flag,'study_dir',study_dir,'tspan',tspan,'solver',solver,'dt',dt,'compile_flag',compile_flag,'verbose_flag',1,'cluster_flag',cluster_flag,'plot_functions',plot_functions,'plot_options',plot_options,'downsample_factor',downsample_factor};

% what you want to vary (for one or more simulations):
% type 'help Vary2Modifications' or see demos for more examples/instructions
% note: these values will override all others
vary={
      'E','amp',[.05];                % set AR(2) amp
      '(E->FS,E->LTS)','gAMPA',[.7];  % set gei
      };
% -------------------------------------------------------------------------

% population size
Ne=200; % 200
Nfs=10; % 10
Nlts=10; % 10

% inputs
iapp_fs=(0:Nfs-1)*.001;
iapp_lts=1.19+(0:Nlts-1)*.005;
amp=.05; % amplitude of AR(2) to E-cells
center=0;

% connection parameters
gei=.7;   % E->I (FS,LTS)
gie=.638; % I->E
gii=.165;
taui=5;
tauie=5;

% connectivity
% kernels
Kei=ones(Ne,Nfs);   % E->I, [N_pre x N_post]
Kie=ones(Nfs,Ne);   % I->E, [N_pre x N_post]
Kii=ones(Nfs,Nfs);  % I->I, [N_pre x N_post]
% normalize kernels by number of presynaptic connections
Kei=Kei./repmat(max(1,sum(Kei,1)),[size(Kei,1) 1]);
Kie=Kie./repmat(max(1,sum(Kie,1)),[size(Kie,1) 1]);
Kii=Kii./repmat(max(1,sum(Kii,1)),[size(Kii,1) 1]);

spec=[];
spec.populations(1).name='E';
spec.populations(1).size=Ne;
spec.populations(1).equations='dV/dt=@current+iapp(k,:); V(0)=-65; iapp=AR2(Npop,T,amp,center); amp=.05; center=0';
spec.populations(1).mechanism_list={'MK08iNa','MK08iK','MK08iM','MK08iLeak'};
spec.populations(1).parameters={'amp',amp,'center',center};

spec.populations(2).name='FS';
spec.populations(2).size=Nfs;
spec.populations(2).equations='dV/dt=@current+iapp; V(0)=-70; iapp=0';
spec.populations(2).mechanism_list={'MK08iNa','MK08iK','MK08iLeak'};
spec.populations(2).parameters={'iapp',iapp_fs};

spec.populations(3).name='LTS';
spec.populations(3).size=Nlts;
spec.populations(3).equations='dV/dt=@current+iapp; V(0)=-70; iapp=0';
spec.populations(3).mechanism_list={'MK08iNa','MK08iK','MK08iM','MK08iLeak'};
spec.populations(3).parameters={'iapp',iapp_lts};

spec.connections(1).direction='E->FS';
spec.connections(1).mechanism_list={'MK08iAMPA'};
spec.connections(1).parameters={'gAMPA',gei,'netcon',Kei};

spec.connections(2).direction='E->LTS';
spec.connections(2).mechanism_list={'MK08iAMPA'};
spec.connections(2).parameters={'gAMPA',gei,'netcon',Kei};

spec.connections(3).direction='FS->E';
spec.connections(3).mechanism_list={'MK08iGABAa'};
spec.connections(3).parameters={'gGABAa',gie,'tauGABAa',tauie,'netcon',Kie};

spec.connections(4).direction='LTS->E';
spec.connections(4).mechanism_list={'MK08iGABAa'};
spec.connections(4).parameters={'gGABAa',gie,'tauGABAa',tauie,'netcon',Kie};

spec.connections(5).direction='FS->LTS';
spec.connections(5).mechanism_list={'MK08iGABAa'};
spec.connections(5).parameters={'gGABAa',gii,'tauGABAa',taui,'netcon',Kii};

spec.connections(6).direction='LTS->FS';
spec.connections(6).mechanism_list={'MK08iGABAa'};
spec.connections(6).parameters={'gGABAa',gii,'tauGABAa',taui,'netcon',Kii};

spec.connections(7).direction='FS->FS';
spec.connections(7).mechanism_list={'MK08iGABAa'};
spec.connections(7).parameters={'gGABAa',gii,'tauGABAa',taui,'netcon',Kii};

spec.connections(8).direction='LTS->LTS';
spec.connections(8).mechanism_list={'MK08iGABAa'};
spec.connections(8).parameters={'gGABAa',gii,'tauGABAa',taui,'netcon',Kii};

% -------------------------------------------------------------------------
%% simulation

data=dsSimulate(spec,'vary',vary,simulator_options{:});
dsPlot(data);
dsPlot(data,'plot_type','rastergram');
dsPlot(data,'plot_type','power');

