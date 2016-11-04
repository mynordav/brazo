%q Son los ángulos de las uniones y n el SC al cual ubicar en SC0
function [p] = directKinematics(q, n)
    global L
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
end