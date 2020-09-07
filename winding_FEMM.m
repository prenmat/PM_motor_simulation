function winding_FEMM(m, q,p, Ns,nr,layer,R_lab,automesh, meshsize,Iabc,g_conduct)% It is possible to generalize to multiphase PH
%xy_slot[x,y] cordinates of centrum of slot
% v is the delta function that says pointly the number of the conductors
%function N is choose to fulfill the constrain of sinusoidal field-->
...medium value is zero-->progressive number of conductors
% Ns # of the slots rotor of stator
% m # of the phase
% q # of slots per pole per phase
% nr pitch reduction in slot number

mi_addcircprop('W1', 0,1);
mi_addcircprop('W2',0,1);
mi_addcircprop('W3', 0,1);
mi_addcircprop('W4', 0,1);
mi_addcircprop('W5', 0,1);
mi_addcircprop('W6', 0,1);
mi_getmaterial('1mm');

phi=0;
turns=1;
for cont=1:p/2
for j=1:layer
    phi=phi+360/Ns*nr*(layer-1);
for  k=1:2*m
for i=1:q
 prop=sprintf('W%d',k);
 mi_selectlabel(-sind(phi)*R_lab(j),R_lab(j)*cosd(phi));
 mi_setblockprop('1mm', automesh, meshsize, prop, 0,g_conduct,turns);
 mi_clearselected
 
phi=phi+360/Ns;
end
end
end
end

%computation
% % for phi=0:dphi:180/pp; %gradi
% %     k=phi/dphi+1;
% %     mi_selectcircle(0,0,D4/2+0.01,4)
% %     mi_moverotate(0,0,dphi)
% % 
% %     sigma=6/turns; %[Arms/mm^2] massima densità di corrente termicamente accettabile
% %     kcu=0.42; %coefficente di riempimento
% %     angolo_cava=passo_cava*(1-rapp_cavadente);
% %     Area_cava=(2*D3/2*sind(angolo_cava/2)+lc)*hc/2;
% %     id=0; %[A] corrente in asse d
% %     iq=sqrt(3)*Area_cava*sigma; %[A]
% % 
% %     phi_elt=(phi*pp); %[rad] angolo elettrico
% %     Rinv = [cosd(phi_elt) sind(phi_elt); -sind(phi_elt) cosd(phi_elt)]; 
% %     iAlfaBeta = Rinv * [id iq]';
% %     Tinv = sqrt(2/3)*[1 0; -0.5 sqrt(3)/2; -0.5 -sqrt(3)/2];
% %     iABC(:,k) = Tinv * iAlfaBeta;
% %     mi_setcurrent('W1', iABC(1,k));
% %     mi_setcurrent('W2', -iABC(2,k));
% %     mi_setcurrent('W3', iABC(3,k));
% %     mi_setcurrent('W4', -iABC(1,k));
% %     mi_setcurrent('W5', iABC(2,k));
% %     mi_setcurrent('W6', -iABC(3,k));
% % 
% %     mi_analyze(0);
% %     mi_loadsolution;
% %     
% % end


    mi_setcurrent('W1', Iabc(1));
    mi_setcurrent('W2', -Iabc(2));
    mi_setcurrent('W3', Iabc(3));
    mi_setcurrent('W4', -Iabc(1));
    mi_setcurrent('W5',Iabc(2));
    mi_setcurrent('W6', -Iabc(3));
    


