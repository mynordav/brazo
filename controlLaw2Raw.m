function stringRaw = controlLaw2Raw(estados)
    U = getControlLaw(1,estados);
    

    direction(U>0) = 1;
    direction(U<0) = 0;
    U = 999-((999*abs(U))/3.2336);
    Duty_cycle = U;
    
    Duty_cycle(Duty_cycle<0) = 0;

    stringRaw = ...
        sprintf('sef%03.0fes%03.0fpe%03.0fba%03.0fdir%d%d%d%d\n', Duty_cycle(1),Duty_cycle(2),...
        Duty_cycle(3), Duty_cycle(4), direction(1),direction(2),direction(3),direction(4));

end

function U = getControlLaw(t,X)
    L  = [0.085 0.115 0.108 0.049];
    K = 1;
    
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

end

function [ref, dref] = getRef(t)
     ref  = [0; 0.2; 0.2];
     dref = 0*[0.1; 0.1*sin(t) + 0.1*t*cos(t); -0.15*t*sin(t) + 0.15*cos(t)];
end