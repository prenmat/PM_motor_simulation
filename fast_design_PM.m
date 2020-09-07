clear all 
close all
clc

%% design of PM
%permissible material stress loadings
%Bts_max maximum value induction teeth stator
Bt_max=1.5;%[T]
%Bys_max maximum value induction yoke stator
Bys_max=1.3;%[T]
%Byr_max maximum value induction yoke rotor
Byr_max=1.3;%[T]
%Jmax Conductors RMS current density
Jmax=10;%[A/mm^2](range of applications -->
...0.5/15 [A/mm^2] stator either rotor)
%%p double pole%%



%Bg1 density of flux in the air gap 1 harmonic peak value
%Dag diameter till air gap [m]
%Lcore length of the PM %[m]
Dag=0.2;%[m]
%Machine aspect ratio lambda=Lcore/Dag;
lambda=0.5;%(range of applications --> 0.5/3)
Lcore=lambda*Dag;


%% magnet data
%mu_r relative permeability
%mu_0 absolute permeability
mu_0=pi*4e-7;%[H/m]
mu_r=1.5;% magnet mu
lm=7;%[mm] %length of magnets
carter=0.8; %Carter coefficent
%air gap
hag=3;%[mm]

%Br residual induction[T]
Br=0.90;
%hag_ equivalent air gap
hag_=hag*carter;% carter can be computated by a single function
%lm_ equivalent length of magnet= lm/mu
lm_=lm/mu_r; %[mm]
%Bg induction all harmonics
disp('minimum value of induction air gap 0.2 T')

Bg=Br*lm_/(lm_+hag_)
disp('maximum value of induction air gap 1 T')
%alfa_m the opening angle of magnets
alfa_m=0.90;%[rad]
%Bg1 fondamental harmonic of Bg
Bg1=4/pi*Bg*sin(alfa_m*pi/2);

%% known the torque we compute the Ks
%Tr=@(Bg1, Ks, Dag, Lcore) sqrt(2)*pi/4*Bg1*Ks*Dag.^2*Lcore;
Tr=35;%[Nm]

Ks=Tr/(sqrt(2)*pi/4*Bg1*Dag.^2*Lcore);
%% 
prop=20; %coefficient of geometry
%p number of poles
%Dis internal stator
delta_is=Dag*1/prop;%[m]
Dis=Dag+delta_is;%[m]
p=8;
%tau_p polar pitch [m]
tau_p=pi*Dis/p
%wm magnet length [m]
wm=alfa_m*tau_p;
%flux per pole
phi_p=Bg*wm*Lcore;
phi_p1=2/pi*Bg1*tau_p*Lcore;
%Byr induction yoke rotor
%Der diameter external rotor
%Dir Diameter internal rotor
%%
%Ki???????
%%
%delta_xy length between the surface [m]
%D_ab internal/external rotor/stator [m]
delta_er=Dag*1/prop%[m]
Der=Dag-delta_er;%[m]
delta_ir=Der*1/prop;%[m] 
Dir=Der-5*delta_ir;%[m]
%
Ki=0.90;%???????
%
Byr=phi_p/2/( (Der-Dir)/2*Lcore*Ki);%[T]

%flux yoke stator
phi_ys=phi_p/2;

%
hys=Bg/Bys_max/Ki*alfa_m*tau_p/2;%[m]


q=1;
%Ns number of slot stator
Ns=3*q*p;
%the effect of leakage flux  evident when
...magnet coverage is large then slots
    %stator solt pitch
tau_s=pi*Dis/Ns%[m]
%if q==1
    %wtt length teeth top
   wtt=Bg/Bt_max/Ki*tau_s;
%else
    %wtt=Bg/Bt_max/Ki*(alfa_m*tau_p-(tau_s-tau_p)/2);
%end


delta_h1=1/prop/5*Dis;%[m]
Dh1=Dis+delta_h1;%[m]
h1=Dh1-Dis;
wst=pi*Dh1/Ns-wtt;%[m]


%% rectangual or trapezoidal slots
flag_slot=1;% 1 to set rectangualr slots 0 trapezoidal
 
if flag_slot
    %kfill slot filling coefficient
%kwdg winding factor
kfill=0.50;
kwdg=0.75;
%Aus useful single slot area 
Aus=Ks*pi*Dh1/(Jmax*1e6*Ns*kwdg*kfill);
 % hus useful height x rectangular slots
 hus=Aus/wst;
 wsb=wst;
 theta=2*asin(wtt/2*Dh1/2);
else
    %
kfill=0.50;
kwdg=0.75;
%Aus useful single slot area 
Aus=Ks*pi*Dh1/(Jmax*1e6*Ns*kwdg*kfill)
 % hus useful height x rectangular slots
 hus=Aus/wst;
    %
    wtb=wtt
     wsb=(pi*(Dh1+2*hus)/Ns)-wtb
    Aus=(wst+wsb/2)*hus
    
    hus=(-wst+sqrt(wst.^2+(4*pi*Aus/Ns)))/(2*pi/Ns)
     theta=2*asin(wtt/2/(Dh1/2));

end
hyr=phi_p/2/(Byr_max*Ki*Lcore);
Des=Dh1+hus+hys;
nr=2;
if nr~=1
    layer=2;
else
    layer=1;
end
fast_plot_PM_FEMM(Lcore,Dir, Der, Dis, Des, Dh1, h1, hus, wst, wsb, theta,Ns,wm,lm,p,layer);
%winding_FEMM(m, q, Dh1/2, )

Ks/100%[A/m]
Ks/100*Jmax%[A^2/mm^2/cm]