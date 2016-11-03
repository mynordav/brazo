
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
tspan = [0 1];
[t, X] = ode23t(@Brazo_sys, tspan, [p0(1:3);th0], odeset('AbsTol', 1e-12));

%Graficar x(t), y(t) y z(t)
figure(1)
plot(t,C*X');
grid on

%Graficar p(t)
figure(2)
plot3(X(:,1),X(:,2),X(:,3));
grid on