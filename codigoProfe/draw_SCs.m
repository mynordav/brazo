function draw_SCs(R, origin)
    hold on
    
    line([0 1.5],[0 0], [0 0],'LineWidth',1,'Color',[1 0 0]); %Eje X (rojo)
    line([0 0],[0 1.5], [0 0],'LineWidth',1,'Color',[0 1 0]); %Eje Y (verde)
    line([0 0],[0 0], [0 1.5],'LineWidth',1,'Color',[0 0 1]); %Eje Z (azul)
    
    for i=1:size(R,3)
        line([origin(1,i) origin(1,i)+R(1,1,i)],[origin(2,i) origin(2,i)+R(2,1,i)], [origin(3,i) origin(3,i)+R(3,1,i)],'LineWidth',1,'Color',[1 0 0]); %Eje X (rojo)
        line([origin(1,i) origin(1,i)+R(1,2,i)],[origin(2,i) origin(2,i)+R(2,2,i)], [origin(3,i) origin(3,i)+R(3,2,i)],'LineWidth',1,'Color',[0 1 0]); %Eje Y (verde)
        line([origin(1,i) origin(1,i)+R(1,3,i)],[origin(2,i) origin(2,i)+R(2,3,i)], [origin(3,i) origin(3,i)+R(3,3,i)],'LineWidth',1,'Color',[0 0 1]); %Eje Z (azul)
    end
end