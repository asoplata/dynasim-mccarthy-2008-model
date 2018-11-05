function Iapp=MM08AR2(Ne,T,amp,center)
%MM08AR2 - Calculate order-2 autoregressive process for input
%
% Purpose:
%     This creates a second-order autoregressive process (AR2) for
%     delta-frequency input into E cells in a model of (McCarthy et
%     al., 2008).
%
% Inputs:
%     Ne: Population size of E cells
%     T: Length of time for the AR2 process to be active
%     amp: Amplitude of the AR2 process signal
%     center: Amplitude center/mean of the process (default: 0)
%
% Outputs:
%     Iapp: Applied stimulus signal to apply to E cells, in uA/cm^2
%
% Notes:
%     - TODO amp may be hardcoded?
%
% References:
%     - McCarthy, M. M., Brown, E. N., & Kopell, N. (2008). Potential
%     Network Mechanisms Mediating Electroencephalographic Beta
%     Rhythm Changes during Propofol-Induced Paradoxical Excitation.
%     The Journal of Neuroscience: The Official Journal of the
%     Society for Neuroscience, 28(50), 13488–13504.
%     https://doi.org/10.1523/JNEUROSCI.3536-08.2008
%
% Author: Jason Sherfey
% Copyright (C) 2018 Jason Sherfey, Boston University, USA
% --------------------------------------------------------------------

if nargin<1, Ne=1; end
if nargin<2, T=0:.01:1000; end
if nargin<3, amp=.05; end
if nargin<4, center=0; end

Nt=length(T);
Iapp=zeros(Nt,Ne);
aone=-1.8744;
atwo=.8785;
epsVar=1;

iapp1=center*ones(1,Ne);
iapp2=center*ones(1,Ne);

for i=1:Nt
  iappHold=-aone*iapp1-atwo*iapp2+randn(1,Ne)*epsVar;
  Iapp(i,:)=amp*iappHold+center;
  iapp2=iapp1;
  iapp1=iappHold;
end

Iapp=max(Iapp,-8);
