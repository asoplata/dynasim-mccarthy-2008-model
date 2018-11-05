function specification = assembleMM08Spec(numCellsScale)
%ASSEMBLEMM08SPEC - Construct and connect the cortex of the (McCarthy et al., 2008) model
%
% assembleMM08Spec builds a (McCarthy et al., 2008)-type DynaSim
% specification, including both its populations and connections from the many
% mechanism files contained in the 'models/' subdirectory.
%
% Inputs:
%   'numCellsScale': number to multiply each cell population size
%                    by aka the proportion; use any non-negative Real number.
%                    To run the full model, use 1. If one wishes to run a
%                    smaller model, use a smaller proportion like 0.2.
%                    Likewise, for a network twice as large, use 2.0.
%
% Outputs:
%   'specification': DynaSim specification structure for the (McCarthy
%                    et al., 2008) model.
%
% Dependencies:
%   - This has only been tested on MATLAB version 2017a.
%
% References:
%     - McCarthy, M. M., Brown, E. N., & Kopell, N. (2008). Potential Network
%     Mechanisms Mediating Electroencephalographic Beta Rhythm Changes during
%     Propofol-Induced Paradoxical Excitation. The Journal of Neuroscience: The
%     Official Journal of the Society for Neuroscience, 28(50), 13488–13504.
%     https://doi.org/10.1523/JNEUROSCI.3536-08.2008
%
% Author: Jason Sherfey
% Copyright (C) 2018 Jason Sherfey, Boston University, USA
% -------------------------------------------------------------------------

%% Population sizes
Ne=200*numCellsScale; % Number E excitatory cells
Nfs=10*numCellsScale; % Number FS inhibitory cells
Nlts=10*numCellsScale;% Number LTS inhibitory cells

%% Input parameters
iapp_fs=(0:Nfs-1)*0.001;
iapp_lts=1.19+(0:Nlts-1)*0.005;
amp=0.05; % amplitude of AR(2) to E-cells
center=0;

%% Synaptic connection parameters
gei=0.7;   % E->I (FS,LTS), AMPA synaptic maximal conductance in mS/cm^2
gie=0.638; % I->E, GABAa synaptic maximal conductance in mS/cm^2
gii=0.165; % I->I, GABAa synaptic maximal conductance in mS/cm^2
taui=5;
tauie=5;

%% Connectivity
% kernels
Kei=ones(Ne,Nfs);   % E->I, [N_pre x N_post]
Kie=ones(Nfs,Ne);   % I->E, [N_pre x N_post]
Kii=ones(Nfs,Nfs);  % I->I, [N_pre x N_post]
% normalize kernels by number of presynaptic connections
Kei=Kei./repmat(max(1,sum(Kei,1)),[size(Kei,1) 1]);
Kie=Kie./repmat(max(1,sum(Kie,1)),[size(Kie,1) 1]);
Kii=Kii./repmat(max(1,sum(Kii,1)),[size(Kii,1) 1]);

%% Specification object creation
spec=[];
specification.populations(1).name='E';
specification.populations(1).size=Ne;
specification.populations(1).equations='dV/dt=@current+iapp(k,:); V(0)=-65; iapp=AR2(Npop,T,amp,center); amp=0.05; center=0';
specification.populations(1).mechanism_list={'MK08iNa','MK08iK','MK08iM','MK08iLeak'};
specification.populations(1).parameters={'amp',amp,'center',center};

specification.populations(2).name='FS';
specification.populations(2).size=Nfs;
specification.populations(2).equations='dV/dt=@current+iapp; V(0)=-70; iapp=0';
specification.populations(2).mechanism_list={'MK08iNa','MK08iK','MK08iLeak'};
specification.populations(2).parameters={'iapp',iapp_fs};

specification.populations(3).name='LTS';
specification.populations(3).size=Nlts;
specification.populations(3).equations='dV/dt=@current+iapp; V(0)=-70; iapp=0';
specification.populations(3).mechanism_list={'MK08iNa','MK08iK','MK08iM','MK08iLeak'};
specification.populations(3).parameters={'iapp',iapp_lts};

specification.connections(1).direction='E->FS';
specification.connections(1).mechanism_list={'MK08iAMPA'};
specification.connections(1).parameters={'gAMPA',gei,'netcon',Kei};

specification.connections(2).direction='E->LTS';
specification.connections(2).mechanism_list={'MK08iAMPA'};
specification.connections(2).parameters={'gAMPA',gei,'netcon',Kei};

specification.connections(3).direction='FS->E';
specification.connections(3).mechanism_list={'MK08iGABAa'};
specification.connections(3).parameters={'gGABAa',gie,'tauGABAa',tauie,'netcon',Kie};

specification.connections(4).direction='LTS->E';
specification.connections(4).mechanism_list={'MK08iGABAa'};
specification.connections(4).parameters={'gGABAa',gie,'tauGABAa',tauie,'netcon',Kie};

specification.connections(5).direction='FS->LTS';
specification.connections(5).mechanism_list={'MK08iGABAa'};
specification.connections(5).parameters={'gGABAa',gii,'tauGABAa',taui,'netcon',Kii};

specification.connections(6).direction='LTS->FS';
specification.connections(6).mechanism_list={'MK08iGABAa'};
specification.connections(6).parameters={'gGABAa',gii,'tauGABAa',taui,'netcon',Kii};

specification.connections(7).direction='FS->FS';
specification.connections(7).mechanism_list={'MK08iGABAa'};
specification.connections(7).parameters={'gGABAa',gii,'tauGABAa',taui,'netcon',Kii};

specification.connections(8).direction='LTS->LTS';
specification.connections(8).mechanism_list={'MK08iGABAa'};
specification.connections(8).parameters={'gGABAa',gii,'tauGABAa',taui,'netcon',Kii};
