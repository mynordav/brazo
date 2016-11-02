
global L K
t = 1;

%Condiciones iniciales de los ángulos
th0 = [degtorad(24) degtorad(10) degtorad(23) degtorad(5)]';
L  = [1.5 2.5 2.5 1.5];

%Obtener transformación final (debe ser igual a A_04)
T = getFinalT_Handler();
T_04 = T(th0(1),th0(2),th0(3),th0(4));

%Condiciones iniciales de la posición del efector final
p0 = T_04*[0;0;0;1];

%Matrices del sistema
A = 0;
C = [eye(3),zeros(3,4)];

K = 10;
%Resolver ODE's
tspan = [0 1];
[t, X] = ode23t(@Brazo_sys, tspan, [p0(1:3);th0], odeset('AbsTol', 1e-12));

figure(1)
plot(t,C*X');
grid on

figure(2)
plot3(X(:,1),X(:,2),X(:,3));
grid on