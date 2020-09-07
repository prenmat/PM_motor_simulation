%% rotor design
function Rotor(Dir, Der,wm,lm,p,meshsize, automesh,g_rotor,g_magnet,g_shaft,max)

%Dir diameter internal rotor
%Der diameter external rotor
%wm radial width magnet
%p number of poles

mi_addnode(Der/2,0); mi_addnode(-Der/2,0); %points
maxseg=3;
mi_addarc(Der/2,0,-Der/2,0,180,maxseg); mi_addarc(-Der/2,0,Der/2,0,180,maxseg); %arcs
mi_selectarcsegment(0,Der/2);mi_selectarcsegment(0,-Der/2);
mi_setgroup(g_magnet)
mi_addnode(Dir/2,0); mi_addnode(-Dir/2,0); %points
maxseg=3;
mi_addarc(Dir/2,0,-Dir/2,0,180,maxseg); mi_addarc(-Dir/2,0,Dir/2,0,180,maxseg); %arcs
hyr=Der/2-Dir/2;
x=sqrt(2)/2*(Dir/2+hyr/2);
y=x;
mi_addblocklabel(-x,y)
mi_selectlabel(-x,y)
mi_getmaterial('Soft magnetic ferrite (Fe-Ni-Zn-V)');
mi_setblockprop('Soft magnetic ferrite (Fe-Ni-Zn-V)', automesh, meshsize,'','', g_rotor ,0);
mi_clearselected;

alfa=wm*360/pi/Der;
 x=Der/2*sind(alfa/2);
 y=Der/2*cosd(alfa/2);
 
 %magnet
 lm=lm*1e-3;
mi_addnode(-x,y);mi_addnode(x,y);
mi_addnode(-x,y+lm);mi_addnode(x,y+lm);
mi_addsegment(-x,y+lm,-x,y);mi_addsegment(x,y+lm,x,y);
mi_addarc(x,y+lm,-x,y+lm,alfa,maxseg)
mi_selectarcsegment(-x,y+lm);
mi_selectsegment(-x,y+lm/2);mi_selectsegment(x,y+lm/2)

mi_setgroup(g_magnet);
mi_selectgroup(g_magnet)
alfa=2*0.9*360*wm/pi/Der;
mi_copyrotate2(0,0,360/p,p-1,4)
%% introduce the direction of density of flux
magnetizz=0;
magnet_l=max+1;
mi_getmaterial('N38')
for cc=0:p-1
 mi_addblocklabel(-(Der/2+lm/2)*sind(360/p*cc),(Der/2+lm/2)*cosd(360/p*cc));

mi_selectlabel(-(Der/2+lm/2)*sind(360/p*cc),(Der/2+lm/2)*cosd(360/p*cc));

mi_setgroup(magnet_l+cc);
mi_selectgroup(magnet_l+cc);
mi_setblockprop('N38', automesh, meshsize,'', 90+360/p*cc+magnetizz,magnet_l+cc,1);
mi_clearselected;
magnetizz=magnetizz+180;
end
for cc=0:p-1
mi_selectlabel(-(Der/2+lm/2)*sind(360/p*cc),(Der/2+lm/2)*cosd(360/p*cc));
mi_setgroup(g_magnet)
end
mi_clearselected
mi_addblocklabel(0,0)
mi_selectlabel(0,0)
%mi_getmaterial('<No mesh>')
mi_setblockprop('<No Mesh>', automesh, meshsize, '', g_shaft, 1,0)
mi_clearselected
    end