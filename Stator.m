function [R_lab] =Stator(Lcore, Dis, Des, Dh1,h1, hus, wst, wsb, theta, Ns,meshsize, automesh, layer,g_stator, g_slot)
%Lcore axial length
%Dis diameter internal stator
%Des diameter external stator
%Dh1 diameter hus
%h1=Dh1-Dis
%wst width of slot bottom
%wsb width of slot top
%theta angular slot pitch
%Ns number of slots
hys=Des/2-Dh1/2-hus;
%% stator design
k=1.1; %+10%
mi_zoom(-Des/2*k,-Des/2*k,Des/2*k,Des/2*k);
mi_addnode(Des/2,0); mi_addnode(-Des/2,0); %points
maxseg=3;
mi_addarc(Des/2,0,-Des/2,0,180,maxseg); mi_addarc(-Des/2,0,Des/2,0,180,maxseg); %arcs

mi_addnode(Dis/2,0); mi_addnode(-Dis/2,0); %points
maxseg=3;
mi_addarc(Dis/2,0,-Dis/2,0,180,maxseg); mi_addarc(-Dis/2,0,Dis/2,0,180,maxseg); %arcs
x=sqrt(2)/2*(Dh1/2+hus+hys/2)
y=x;
mi_getmaterial('Soft magnetic ferrite (Fe-Ni-Zn-V)');
mi_addblocklabel(x,y)
mi_selectlabel(x,y)
mi_setblockprop('Soft magnetic ferrite (Fe-Ni-Zn-V)', automesh, meshsize,'','', g_stator ,0);
mi_clearselected;


%% slot design
%lowest points
mi_addnode(-wst/2,Dh1/2);
mi_addnode(wst/2,Dh1/2);

%highest points
mi_addnode(-wsb/2, Dh1/2+hus)
mi_addnode(wsb/2, Dh1/2+hus)
 alfa=2*asin(wsb/2/(Dh1/2+hus));
%lateral segments
mi_addsegment(-wst/2,Dh1/2,-wsb/2, Dh1/2+hus); mi_addsegment(wst/2,Dh1/2,wsb/2, Dh1/2+hus); %segment
mi_addarc(wsb/2,Dh1/2+hus, -wsb/2,Dh1/2+hus,alfa,maxseg)
wo=wst/1.2;
 alfa1=2*asin(wo/2/Dis/2);
 %xy inner points
 x=Dis/2*sin(alfa1);
 y=Dis/2*cos(alfa1)
 
 if layer==1
     %oblique segments 
mi_addnode(-x,y);mi_addnode(x,y);
mi_addsegment(-x,y, -wst/2, Dh1/2);mi_addsegment(x,y, wst/2, Dh1/2);

%medium point slot

mi_selectarcsegment(0,Dh1/2+hus);
%mi_copyrotate2(0, 0, 360/Ns, Ns,3 );

mi_selectsegment(-wst,Dh1/2+hus/2);
%mi_copyrotate2(0, 0, 360/Ns, Ns,1 );

mi_selectsegment(wst,Dh1/2+hus/2)
%mi_copyrotate2(0, 0, 360/Ns, Ns,1 );

mi_selectsegment(-x/2 -wst/2/2, Dh1/2/2+y/2);
%mi_copyrotate2(0, 0, 360/Ns, Ns,1 );

mi_selectsegment(x/2+wst/2/2, Dh1/2/2+y/2);
%mi_copyrotate2(0, 0, 360/Ns, Ns,1 );
R_lab=Dh1/2+hus/2;
mi_addblocklabel(0,R_lab)
mi_selectlabel(0,R_lab)
 else
mi_addnode(-x,y);mi_addnode(x,y);
mi_addsegment(-x,y, -wst/2, Dh1/2);mi_addsegment(x,y, wst/2, Dh1/2);
%new layer
mi_addnode(-wsb/2, Dh1/2+hus/layer);mi_addnode(wsb/2, Dh1/2+hus/layer)
alfa2=2*asin(wsb/(Dh1/2+hus/layer));
%new acr
mi_addarc(wsb,Dh1/2+hus/layer,-wsb,Dh1/2+hus/layer,alfa2,maxseg)

%medium point slot
%medium point slot
mi_selectarcsegment(0,Dh1/2+hus);
%mi_copyrotate2(0, 0, 360/Ns, Ns,3 );

mi_selectsegment(-wst/2,Dh1/2+hus/4);
mi_selectsegment(-wst/2,Dh1/2+hus*3/4);

mi_selectsegment(wst/2,Dh1/2+hus/4)
mi_selectsegment(wst/2,Dh1/2+hus*3/4)

mi_selectarcsegment(0,Dh1/2+hus/layer)


mi_selectsegment(-x/2 -wst/2/2, Dh1/2/2+y/2);
%mi_copyrotate2(0, 0, 360/Ns, Ns,1 );


mi_selectsegment(x/2+wst/2/2, Dh1/2/2+y/2);
R_lab=[Dh1/2+hus/4, Dh1/2+hus*3/4]
mi_addblocklabel(0,R_lab(1))
mi_selectlabel(0,R_lab(1))
mi_addblocklabel(0,R_lab(2))
mi_selectlabel(0,R_lab(2))
end

mi_setgroup(g_slot)
mi_selectgroup(g_slot)
mi_copyrotate2(0,0,360/Ns,Ns-1,4)
%%


end