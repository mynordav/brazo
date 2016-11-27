function Angles = getAnglesFromKinectPoints(EF,SE,PE,BA,O)
%% Definiciones iniciales COMENTAR ESTO AL FINAL
L  = [0.10 0.115 0.108 0.049];
BA = [5 0 5; 10 0 10];
PE = [0 -5 0; 0 -10 0];
SE = [5 0 0; 10 0 0];
EF = [0 5 0; 0 10 0];
O  = [5 5 5];

%% Definicion de referencias
Ref_BA_V = [0 1 0];
Ref_PE_ =  [0 0 1];
Ref_SE_ =  [0 1 0];
Ref_EF_ =  [0 0 -1];

%% Rotaciones y traslaciones correspondientes Kinect a base

K2 =  [ 0 1  0 0;
        0 0 -1 0;
       -1 0  0 0;
        0 0  0 1];
KB =  [ 1 0  0 O(1);
        0 1  0 O(2);
        0 0  1 O(3);
        0 0  0   1];
K2B = K2*KB;   
BArot = [BA [1,1]']*K2B;
BArot = BArot(:,1:3);
BA_V = BArot(2,:)-BArot(1,:);
Angles(1) = acos(dot(BA_V,Ref_BA_V)/(norm(BA_V)*norm(Ref_BA_V)));
rad2deg(Angles(1))

%% Rotaciones y traslaciones correspondientes base a primer eslabon
s1 = sin(Angles(1)); c1 = cos(Angles(1));

A_01 = [-s1, 0, c1,  0;
         c1, 0, s1,  0;
         0,  1,  0,  L(1);
         0,  0,  0,  1  ];
     
PErot = [PE [1,1]']*K2B*A_01;
Ref_PE_V = [Ref_PE_ 1]*A_01;
Ref_PE_V = Ref_PE_V(1:3);
PErot = PErot(:,1:3);
PE_V = PErot(2,:) - PErot(1,:);
Angles(2) = acos(dot(PE_V,Ref_PE_V)/(norm(PE_V)*norm(Ref_PE_V)));
rad2deg(Angles(2))

%% Rotaciones y traslaciones correspondientes primer a segundo eslabon
s2 = sin(Angles(2)); c2 = cos(Angles(2));


A_12 = [ s2, c2, 0,  -L(2)*s2;
        -c2, s2, 0,   L(2)*c2;
          0,  0, 1,         0;
          0,  0, 0,         1];
      
SErot = [SE [1,1]']*K2B*A_01*A_12;
Ref_SE_V = [Ref_SE_ 1]*A_01*A_12;
Ref_SE_V = Ref_SE_V(1:3);
SErot = SErot(:,1:3);
SE_V = SErot(2,:) - SErot(1,:);
Angles(3) = acos(dot(SE_V,Ref_SE_V)/(norm(SE_V)*norm(Ref_SE_V)));
rad2deg(Angles(3))    


%% Rotaciones y traslaciones correspondientes segundo a primer eslabon
s3 = sin(Angles(3)); c3 = cos(Angles(3));

A_23 = [ s3, c3, 0, -L(3)*s3;
        -c3, s3, 0,  L(3)*c3;
          0,  0, 1,        0;
          0,  0, 0,        1];  

      
EFrot = [EF [1,1]']*K2B*A_01*A_12*A_23;
Ref_EF_V = [Ref_EF_ 1]*A_01*A_12*A_23;
Ref_EF_V = Ref_EF_V(1:3);
EFrot = EFrot(:,1:3);
EF_V = EFrot(2,:) - EFrot(1,:);
Angles(4) = acos(dot(EF_V,Ref_EF_V)/(norm(EF_V)*norm(Ref_EF_V)));
rad2deg(Angles(4))



end