%Usarlo: [Jv, Jw] = getJacobian(A_01, A_12, A_23, A_34);
function [Jv, Jw] = getJacobian(varargin)
    %Establecer dimensiones de los jacobianos
    Jw = zeros(3, nargin);
    Jv = zeros(3, nargin);
    A = zeros(4, 4, nargin + 1);
    %Esta matriz contiene todas las matrices de transformación

    %Debido a que hay que obtener z0 en la primera iteración y z0
    %siempre es [0 0 1]' la primera vez es necesario multiplicar por 
    %la identidad
    A(:,:,1) = eye(4);

    %Vectores auxiliares para obtener los valores de zi-1 y Oi-1
    k = [0 0 1]';
    O = [0 0 0 1]';
    
    %Esta matriz transforma del SC del efector final al SC inercial
    %Se utiliza para obtener el On, la posición del efector final
    A_0n = eye(4);

    %Llenar la matriz de matrices de transformación y obtener la
    %matriz de transformación final A_0n
    for i = 1:nargin
        A(:,:,i+1) = varargin{i};
        A_0n = A_0n*varargin{i};
    end

    %Obtener posición de On conrespecto al SC inercial
    O_0n = A_0n*O;
    O_0n = O_0n(1:3);
    
    %Matriz auxiliar para representar una transformación del
    %SC i-1 en coordenadas del SC inercial
    A_0im1 = eye(4);
    
    
    for i = 1:nargin
        %Jacobiano de vel angular
        tmp = eye(3);
        for j = 1:i
            tmp = tmp*A(1:3,1:3,j);
            Jw(:,i) = tmp*k;
        end
        
        %Obtener origen del SC i-1 con respecto a SC0
        A_0im1 = A_0im1*A(:,:,i);
        O_im1 = A_0im1*O;
        O_im1 = O_im1(1:3);
        
        %Jacobiano de vel lineal
        Jv(:,i) = cross(Jw(:,i), O_0n - O_im1);
    end
    
end

