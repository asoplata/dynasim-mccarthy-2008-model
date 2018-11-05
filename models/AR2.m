function Iapp=AR2(Ne,T,amp,center)
% AR(2)
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
