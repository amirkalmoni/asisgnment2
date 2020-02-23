L = 75;
W = 50;
g_matix = sparse((W * L), (W * L));
H = zeros(1,(W*L));
vo = 1;

condout = 1; 
condin = 10e-2; 
inner1 = [(L* 1/4), (L * 2.5/4), 0, (W * 1.5/4)];
inner2 = [(L * 1/4), (L * 2.5/4),  W, (W * 3/4)];


    
    
  for v = 1:1:L

    for o = 1:1:W
        
        k = o + (v - 1) * W;
        nym = o + ((v - 1)-1)*W;
        nyp = o + ((v + 1)-1)*W;
        nxm = (o-1) + (v - 1)*W;
        nxp = (o+1) + (v - 1)*W;
        if v == 1
            g_matix(k, :) = 0;
            g_matix(k, k) = 1;
            H(1, k) = 1;
        elseif v == L
            g_matix(k, :) = 0;
            g_matix(k, k) = 1;
            
        elseif o == 1 && v > 1 && v < L
            
            if v == inner2(1)
                g_matix(k, k) = -3;
                g_matix(k, nyp) = condin;
                g_matix(k, nxp) = condin;
                g_matix(k, nxm) = condout;
            
            elseif v == inner2(2)
                g_matix(k, k) = -3;
                g_matix(k, nyp) = condin;
                g_matix(k, nxp) = condout;
                g_matix(k, nxm) = condin;
                
            elseif (v > inner2(1) && v < inner2(2))
                g_matix(k, k) = -3;
                g_matix(k, nyp) = condin;
                g_matix(k, nxp) = condin;
                g_matix(k, nxm) = condin;
            else
                g_matix(k, k) = -3;
                g_matix(k, nyp) = condout;
                g_matix(k, nxp) = condout;
                g_matix(k, nxm) = condout;
            end
            
        elseif o == W && v > 1 && v < L
            
            if v == inner2(1)
                g_matix(k, k) = -3;
                g_matix(k,nym) = condin;
                g_matix(k, nxp) = condin;
                g_matix(k, nxm) = condout;
            
            elseif v == inner2(2)
                g_matix(k, k) = -3;
                g_matix(k, nym) = condin;
                g_matix(k, nxp) = condout;
                g_matix(k, nxm) = condin;
                
            elseif (v > inner2(1) && v < inner2(2)) 
                g_matix(k, k) = -3;
                g_matix(k, nym) = condin;
                g_matix(k, nxm) = condin;
                g_matix(k, nxm) = condin;
            else 
                g_matix(k, k) = -3;
                g_matix(k, nym) = condout;
                g_matix(k, nxp) = condout;
                g_matix(k, nxm) = condout;
            end
            
        else
            
            if v == inner2(1) && ((o < inner1(4)) || (o > inner2(4)))
                g_matix(k, k) = -4;
                g_matix(k, nyp) = condin;
                g_matix(k, nym) = condin;
                g_matix(k, nxp) = condin;
                g_matix(k, nxm) = condout;
            
            elseif v == inner2(2) && ((o < inner1(4)) || (o > inner2(4)))
                g_matix(k, k) = -4;
                g_matix(k, nyp) = condin;
                g_matix(k, nym) = condin;
                g_matix(k, nxp) = condout;
                g_matix(k, nxm) = condin;
                
            elseif (v > inner2(1) && v < inner2(2) && ((o < inner1(4)) || (o > inner2(4))))
                g_matix(k, k) = -4;
                g_matix(k, nyp) = condin;
                g_matix(k, nym) = condin;
                g_matix(k, nxp) = condin;
                g_matix(k, nxm) = condin;
            else
                g_matix(k, k) = -4;
                g_matix(k, nyp) = condout;
                g_matix(k, nym) = condout;
                g_matix(k, nxp) = condout;
                g_matix(k, nxm) = condout;
            end
           
        end
    end
                

  end 
  

cond = ones(L, W);

for v = 1:1:L
    
    for o = 1:1:W
        if(v > inner2(1) && v < inner2(2) && ((o < inner1(4)) || (o > inner2(4))))
            cond(v,o) = 10e-2;
        end
    end
    
end
    
figure(5);
surf(cond);
title('Conductivity Mapping ?(x,y)');


Z = g_matix\H';
Vbot = zeros(L,W);
for v = 1:1:L

    for o = 1:1:W
        n = o + (v - 1) * W;
        Vbot(v, o) = Z(n);
    end
end

figure (6);
surf(Vbot);
title('Voltage Map of Bottleneck V(x,y)');

[ElectroY, ElectroX] = gradient(Vbot);
DEN = cond.*gradient(Vbot);

ElectroX = -ElectroX;
ElectroY = -ElectroY;
figure(7)
surf(ElectroX)
title('X Direction of the Electric Field')

figure(8)
surf(ElectroY)
title('Y Direction of the Electric Field')



figure(9)
surf(DEN)
title('Current Density Magnitude plot')

bnvec = zeros(1, 100);
currvec = zeros(1, 200);
for condu = 1:10
  bnvec(condu) = condin;
  bnvec = L*currvec + W;
  cflow2 = sum(sum(DEN))/(L*W)
  currvec(condu) = cflow2;
  condin = condin + 0.01;   
end


figure(10)
plot(bnvec, currvec);
title('Current vs Conductivity');