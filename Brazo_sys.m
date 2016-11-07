function dX = Brazo_sys(t, X)
    global K L 
    
    %X = [x, y, z, th1, th2, th3, th4]
    
    th = X(4:end);
              
    A_01 = [-sin(th(1)), 0, cos(th(1)),  0;
             cos(th(1)), 0, sin(th(1)),  0;
                  0,     1,      0,     L(1);
                  0,     0,      0,      1   ];

    A_12 = [ sin(th(2)), cos(th(2)), 0,  -L(2)*sin(th(2));
            -cos(th(2)), sin(th(2)), 0,   L(2)*cos(th(2));
                  0,          0,     1,          0;
                  0,          0,     0,          1        ];  

    A_23 = [ sin(th(3)), cos(th(3)), 0, -L(3)*sin(th(3));
            -cos(th(3)), sin(th(3)), 0,  L(3)*cos(th(3));
                  0,          0,     1,          0;
                  0,          0,     0,          1        ];  

    A_34 = [ cos(th(4)), -sin(th(4)), 0, -L(4)*cos(th(4));
             sin(th(4)),  cos(th(4)), 0, -L(4)*sin(th(4));
                  0,          0,      1,          0;
                  0,          0,      0,          1        ]; 
              
    J = getJacobian(A_01, A_12, A_23, A_34);          
    
    B = [J;eye(4)];
    
    [ref, dref] = getRef(t);

    pinvJ = pinv(J);
    
    U = pinvJ*(dref + K*ref - K*X(1:3));
    
    dX = B*U;
end

function [ref, dref] = getRef(t)
     ref  = [0.1*t; 0.1*t*sin(t); 3 + 0.15*t*cos(t)];
     dref = [0.1; 0.1*sin(t) + 0.1*t*cos(t); -0.15*t*sin(t) + 0.15*cos(t)];
end