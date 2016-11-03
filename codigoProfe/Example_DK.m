function Example_DK(t_lim, step, config, DH)

%Define un manipulador con sus parámetros DH y config y calcula la
%cinemática directa para varios valores de q
% DH(i,:) = {a_i,alpha_i,d_i,theta_i}

    [config, DH] = options_DK(config, DH);
    
    t = 0:step:t_lim;                      %Vector de Tiempo
    q = zeros(max(size(config)),1);        %Vector de Valores de Unión
    pos_plot = zeros(3, max(size(t)));
    n = max(size(config));
    
    hold on;
    
    for i=1:size(t,2)
        q(1) = t(i);
        q(2) = sin(8.5*t(i));
        q(3) = 2*cos(8.5*t(i));
        [origin, R, A] = Dir_Kin(DH, q, config);
        pos_plot(:,i) = origin(:,n);
    
        %Animación
        clf('reset');
        draw_SCs(R, origin);
        plot3(pos_plot(1,:),pos_plot(2,:),pos_plot(3,:));
        line([0 origin(1,1)],[0 origin(2,1)], [0 origin(3,1)],'LineWidth',4,'Color',.4*[1 1 1]);
        for j=1:max(size(config))-1
            line([origin(1,j) origin(1,j+1)],[origin(2,j) origin(2,j+1)], [origin(3,j) origin(3,j+1)],'LineWidth',4,'Color',[j/(max(size(config))-1) 0 j/(max(size(config))-1)]);
        end
    
        grid on;  axis([-10 10 -10 10 0 13]);  view([1 1 .5]);
        pause(.05)
    end
    hold off;
end
