numx = 40;
numy = 60;
g_mat0 = sparse((numx * numy), (numx * numy));
v_mat0 = zeros(1, (numx * numy));


for i = 1:numx

    for k = 1:numy
        n = k + (i - 1) * numy;
        
        if i == 1
            g_mat0(n, :) = 0;
            g_mat0(n, n) = 1;
            v_mat0(1, n) = 1;
        elseif i == numx
            g_mat0(n, :) = 0;
            g_mat0(n, n) = 1;
        elseif k == 1 && i > 1 && i < numx
            g_mat0(n, n) = -3;
            g_mat0(n, n - numy) = 1;
            g_mat0(n, n + numy) = 1;
            g_mat0(n, n - 1) = 1;
        elseif k == numy && i > 1 && i < numx
            g_mat0(n, n) = -3;
            g_mat0(n, n - numy) = 1;
            g_mat0(n, n + numy) = 1;
            g_mat0(n, n + 1) = 1;
        else
            g_mat0(n, n) = -4;
            g_mat0(n, n - numy) = 1;
            g_mat0(n, n + numy) = 1;
            g_mat0(n, n - 1) = 1;
            g_mat0(n, n + 1) = 1;
        end
    end
                

end 

figure (1);
spy(g_mat0);
solution1 = g_mat0\v_mat0';

figure (2);
actmat = zeros(numx, numy);

for i = 1:numx

    for k = 1:numy
        n = k + (i - 1) * numy;
        actmat(i, k) = solution1(n);
    end
end
surf(actmat);



%%Question 1: Part B
numx = 40;
numy = 60;
g_mat1 = sparse((numx * numy), (numx * numy));
v_mat1 = zeros(1, (numx * numy));
v_o = 1;

for i = 1:numx

    for k = 1:numy
        n = k + (i - 1) * numy;
        
        if i == 1
            g_mat1(n, :) = 0;
            g_mat1(n, n) = 1;
            v_mat1(1, n) = v_o;
        elseif i == numx
            g_mat1(n, :) = 0;
            g_mat1(n, n) = 1;
            v_mat1(1, n) = v_o;
        elseif k == 1
            g_mat1(n, :) = 0;
            g_mat1(n, n) = 1;
        elseif k == numy
            g_mat1(n, :) = 0;
            g_mat1(n, n) = 1;
        else
            g_mat1(n, :) = 0;
            g_mat1(n, n) = -4;
            g_mat1(n, n - numy) = 1;
            g_mat1(n, n + numy) = 1;
            g_mat1(n, n - 1) = 1;
            g_mat1(n, n + 1) = 1;
        end
    end          
end 

figure (3);
spy(g_mat1);
solution2 = g_mat1\v_mat1';

figure (4);
xlabel('x') 
ylabel('y')
zlabel('V(x,y)')

actmat2 = zeros(numx, numy);


for i = 1:numx

    for k = 1:numy
        n = k + (i - 1) * numy;
        actmat2(i, k) = solution2(n);
    end
end
   
surf(actmat2);


%%Question 1: Part B - Analytical Solution Approach

zone = zeros(60, 40);
a = 60;
b = 20;

x_s = linspace(-20,20,40);
y_s = linspace(0,60,60);

[xm, ym] = meshgrid(x_s, y_s);



for n = 1:2:300
    
    zone =  (zone + (4 * v_o/pi) .*(cosh((n * pi * xm)/a) .* sin((n * pi * ym)/a)) ./ (n * cosh((n * pi * b)/a)));
    
    figure(5);
    surf(x_s, y_s, zone);
    title("Analytical Approach Solution");
    pause(0.01);
    
end
