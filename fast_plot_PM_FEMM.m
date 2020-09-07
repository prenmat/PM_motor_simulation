function [Tr]=fast_plot_PM(Lcore,Dir, Der, Dis, Des, Dh1,h1, hus, wst, wsb, theta, Ns,wm,lm,p, layer, nr, m, q,Iabc,alfa_mag)

addpath('c:\\femm42\\mfiles')
openfemm

%% definition of the problem
freq=0;%Hz
units='meters'; %units
type='planar'; %Type of the problem
precision=1E-8;
elementsize=33;
acsolver=0; %0 Approximation mode, 1 Newton mode
minangle=30;
newdocument(0);
mi_probdef(freq,units,type,precision,Lcore,minangle,acsolver);
mi_smartmesh(0);
meshsize=0; % se non settato su automesh dimensione mesh dei blocchi
automesh=1; % set automesh
global g_shaft; 
g_shaft=1;
global g_slot;
g_slot=2;
global g_magnet;
g_magnet=3;
global g_conduct;
g_conduct=4;
global g_rotor;
g_rotor=5;
global g_stator;
g_stator=6;
global max;%group of selection
max=7
%% design of the machine
R_lab=Stator(Lcore, Dis, Des, Dh1,h1, hus, wst, wsb, theta, Ns,meshsize, automesh,layer,g_stator,g_slot);
Rotor(Dir, Der,wm,lm,p,meshsize, automesh, g_rotor,g_magnet,g_shaft,max);
mi_getmaterial('Air')
mi_addblocklabel(0,-(Der/4+Dis/4+lm*1e-3/2))
mi_selectlabel(0,-(Der/4+Dis/4+lm*1e-3*1/2))
mi_setblockprop('Air', automesh, meshsize,'','', 0 ,0);
%Boundary condition
mi_selectarcsegment(0,Des/2);
mi_selectarcsegment(0,-Des/2);
mi_setarcsegmentprop(3,'A=0',0,7);
mi_saveas('PM_motor.FEM')
winding_FEMM(m, q,p, Ns,nr,layer,R_lab,automesh, meshsize,Iabc,g_conduct)
mi_selectgroup(g_magnet)
mi_moverotate(0,0,alfa_mag)
mi_analyze(0);
mi_loadsolution;
    
   mo_groupselectblock(g_conduct);
   mo_groupselectblock(g_stator);
  
   Tr=-mo_blockintegral(22); %coppia con stress tensor
end