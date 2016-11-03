
global L K

%Condiciones iniciales de los ángulos
th0 = [degtorad(24) degtorad(10) degtorad(23) degtorad(5)]';
L  = [1.5 2.5 2.5 1.5];

%Obtener transformación final (debe ser igual a A_04)


%Condiciones iniciales de la posición del efector final
p0 = directKinematics(th0, 4);

%Matriz C
C = [eye(3),zeros(3,4)];

% Ganancia de control
K = 10;

%Resolver ODE's
tspan = [0 50];
[t, X] = ode23t(@Brazo_sys, tspan, [p0(1:3);th0], odeset('AbsTol', 1e-12));



%Graficar x(t), y(t) y z(t)
figure(1)

p = zeros(4,4);
colors = ['r', 'g', 'b', 'm'];

for i = 1:numel(t)
    clf('reset');
    
    p(:,1) = [0 0 0 1];
    for j = 1:4
        p(:,j+1) = directKinematics(X(i,4:7),j);
    end
    
        scatter3(p(1,:), p(2,:), p(3,:), 72, 'filled');
        hold on
    for j = 1:4
        plot3([p(1,j), p(1,j+1)], [p(2,j), p(2,j+1)], [p(3,j), p(3,j+1)],...
              'r','LineWidth',4);
    end
    
    plot3(X(1:i,1),X(1:i,2),X(1:i,3));
    grid on;
    axis([-10 10 -10 10 0 13]);  view([0 0 4]);
    pause(0.1);
end
hold off;

%Graficar p(t)
figure(2)
plot(t, C*X');
grid on