function stringRaw = controlLaw2Raw(estados)
    offset = [0 300 400 300];
    estados(1:3) =  directKinematics(estados(4:7),4);
    disp('Posicion de efector final:');
    disp(estados(1:3)');
    U = getControlLaw(1,estados);
    disp('Ley de control:');
    disp(U');  
    direction(U>0) = 1;
    direction(U<0) = 0;

    Duty_cycle(1) = 999-(((999 - offset(1))*abs(U(1)))/3.2336) - offset(1);
    Duty_cycle(2) = 999-(((999 - offset(2))*abs(U(2)))/3.2336) - offset(2);
    Duty_cycle(3) = 999-(((999 - offset(3))*abs(U(3)))/3.2336) - offset(3);
    Duty_cycle(4) = 999-(((999 - offset(4))*abs(U(4)))/3.2336) - offset(4);

    
    Duty_cycle(Duty_cycle<0) = 0;
    disp('Duty Cycle:')
    disp(Duty_cycle')
    disp('Direction:')
    disp(direction)
    
    stringRaw = sprintf('sef%03.0fes%03.0fpe%03.0fba%03.0fdir%d%d%d%d\n',...
        Duty_cycle(4), Duty_cycle(3), Duty_cycle(2),  Duty_cycle(1),...
        direction(4),direction(3),direction(2),direction(1));

        

end

function U = getControlLaw(t,X)
    L  = [0 0.115 0.108 0.049];
    K = [0.1 0 0;
         0  0.5 0;
         0   0  0.7];
    
    th = X(4:end);
    
    s1 = sin(th(1)); c1 = cos(th(1));
    s2 = sin(th(2)); c2 = cos(th(2));
    s3 = sin(th(3)); c3 = cos(th(3));
    s4 = sin(th(4)); c4 = cos(th(4));
    
    A_01 = [-s1, 0, c1,  0;
             c1, 0, s1,  0;
             0,  1,  0, L(1);
             0,  0,  0,  1  ];

    A_12 = [ s2, c2, 0,  -L(2)*s2;
            -c2, s2, 0,   L(2)*c2;
              0,  0, 1,         0;
              0,  0, 0,         1];  

    A_23 = [ s3, c3, 0, -L(3)*s3;
            -c3, s3, 0,  L(3)*c3;
              0,  0, 1,        0;
              0,  0, 0,        1];  

    A_34 = [ c4, -s4, 0, -L(4)*c4;
             s4,  c4, 0, -L(4)*s4;
              0,   0, 1,        0;
              0,   0, 0,        1]; 
              
    J = getJacobian(A_01, A_12, A_23, A_34);          
    
    
    [ref, dref] = getRef(t);

    pinvJ = pinv(J);
    
    U = pinvJ*(dref + K*ref - K*X(1:3));
    disp('Error :')
    disp((ref - X(1:3))')
    
end

%q Son los ángulos de las uniones y n el SC al cual ubicar en SC0
function [p] = directKinematics(q, n)
    L  = [0 0.115 0.108 0.049];
    A_01 = [-sin(q(1)), 0, cos(q(1)),  0;
             cos(q(1)), 0, sin(q(1)),  0;
                  0,     1,      0,     L(1);
                  0,     0,      0,      1   ];

    A_12 = [ sin(q(2)), cos(q(2)), 0,  -L(2)*sin(q(2));
            -cos(q(2)), sin(q(2)), 0,   L(2)*cos(q(2));
                  0,          0,     1,          0;
                  0,          0,     0,          1        ];  

    A_23 = [ sin(q(3)), cos(q(3)), 0, -L(3)*sin(q(3));
            -cos(q(3)), sin(q(3)), 0,  L(3)*cos(q(3));
                  0,          0,     1,          0;
                  0,          0,     0,          1        ];  

    A_34 = [ cos(q(4)), -sin(q(4)), 0, -L(4)*cos(q(4));
             sin(q(4)),  cos(q(4)), 0, -L(4)*sin(q(4));
                  0,          0,      1,          0;
                  0,          0,      0,          1        ];  
              
    A(:,:,1) = A_01;
    A(:,:,2) = A_12;
    A(:,:,3) = A_23;
    A(:,:,4) = A_34;
    
    A_0n = eye(4);
    
    p = [0 0 0 1]';
    
    for i = 1:n
        A_0n = A_0n*A(:,:,i);
    end
    
    p = A_0n*p;
    p = p(1:3);
end


function [ref, dref] = getRef(t)
     L  = [0 0.115 0.108 0.049];
     ref  = [0; cos(pi/4)*(0.108+0.049); sin(pi/4)*(0.108+0.049)+0.115 ];
     dref = 0*[0.1; 0.1*sin(t) + 0.1*t*cos(t); -0.15*t*sin(t) + 0.15*cos(t)];
end