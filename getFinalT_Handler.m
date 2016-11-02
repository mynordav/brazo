function [T] = getFinalT_Handler()     
    global L

    th = sym('th', [1,4]);

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

    A_04 = A_01*A_12*A_23*A_34;
    
    T = matlabFunction(A_04);
end