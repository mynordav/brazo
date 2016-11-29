%initKinect();
global C1 C2 C3 C4 

C2 = struct('R', uint8(135), 'G', uint8(125), 'B',  uint8(50) , 'TH', uint8(15)); % efector final       
C1 = struct('R', uint8(185), 'G', uint8(55),  'B',  uint8(45) , 'TH', uint8(20)); % segundo eslabon       
C3 = struct('R', uint8(15) , 'G', uint8(35),  'B',  uint8(100), 'TH', uint8(20)); % primer eslabon
C4 = struct('R', uint8(150), 'G', uint8(185), 'B',  uint8(80),  'TH', uint8(10)); % Origen 

efec_fin = struct('x1', 0, 'x2', 0, 'y1', 0, 'y2', 0, 'z1', 0, 'z2', 0);
seg_es   = struct('x1', 0, 'x2', 0, 'y1', 0, 'y2', 0, 'z1', 0, 'z2', 0);
prim_es  = struct('x1', 0, 'x2', 0, 'y1', 0, 'y2', 0, 'z1', 0, 'z2', 0);

while(1)
    try 
    tic
        colorImage = step(colorVid);
        depthImage = step(depthVid);
        ptCloud = pcfromkinect(depthVid, depthImage,colorImage);

        %% Get Origin

        center = find((colorImage(:,:,1) > (C4.R - C4.TH) & colorImage(:,:,1) < (C4.R + C4.TH) ...
                     & colorImage(:,:,2) > (C4.G - C4.TH) & colorImage(:,:,2) < (C4.G + C4.TH)...
                     & colorImage(:,:,3) > (C4.B - C4.TH) & colorImage(:,:,3) < (C4.B + C4.TH) ));

        [col, row] = getCoordinates(center, 1080);

        %% Color Filters

        %Final Efector
        ba = colorFilter(colorImage, C2, 'G');
        %Second Efector
        br_V = colorFilter(colorImage, C1, 'R');
        %Third Efector
        ba_A = colorFilter(colorImage, C3, 'B');

        %% Compute Hough Transforms

        figure(1), imshow(colorImage), hold on

        avg = getHoughTransform(ba, 200, 50, 'AVG');
        efecFin = avg;
        plot(efecFin(:,1),efecFin(:,2),'LineWidth',2,'Color','yellow');

        avg = getHoughTransform(br_V, 300, 50, 'MAX');
        segundo_eslabon = avg;
        plot(segundo_eslabon(:,1),segundo_eslabon(:,2),'LineWidth',2,'Color','red');

        avg = getHoughTransform(ba_A, 300, 50, 'AVG');
        tercer_eslabon = avg;
        plot(tercer_eslabon(:,1),tercer_eslabon(:,2),'LineWidth',2,'Color','blue');


        %% Plotting the center
        plot(col, row,'xr:', 'MarkerSize', 15)

        x_dim = flipdim(ptCloud.Location(:,:,1),2);
        y_dim = flipdim(ptCloud.Location(:,:,2),2);
        z_dim = flipdim(ptCloud.Location(:,:,3),2);

        %% Getting each pair of x,y,z points for each Efector
        % Origin
        origin = [x_dim(row, col) y_dim(row, col) (z_dim(row, col) - 0.0775)];
        center = origin;

        % Final Efector point coordinates
        efec_fin.x1 = x_dim(efecFin(3), efecFin(1));
        efec_fin.x2 = x_dim(efecFin(4), efecFin(2));

        efec_fin.y1 = y_dim(efecFin(3), efecFin(1));
        efec_fin.y2 = y_dim(efecFin(4), efecFin(2));

        efec_fin.z1 = z_dim(efecFin(3), efecFin(1));
        efec_fin.z2 = z_dim(efecFin(4), efecFin(2));

        % Second 'Eslabon' point coordinates
        seg_es.x1 = x_dim(segundo_eslabon(3), segundo_eslabon(1));
        seg_es.x2 = x_dim(segundo_eslabon(4), segundo_eslabon(2));

        seg_es.y1 = y_dim(segundo_eslabon(3), segundo_eslabon(1));
        seg_es.y2 = y_dim(segundo_eslabon(4), segundo_eslabon(2));

        seg_es.z1 = z_dim(segundo_eslabon(3), segundo_eslabon(1));
        seg_es.z2 = z_dim(segundo_eslabon(4), segundo_eslabon(2));

        % Third 'Eslabon' point coordinates
        prim_es.x1 = x_dim(tercer_eslabon(3), tercer_eslabon(1));
        prim_es.x2 = x_dim(tercer_eslabon(4), tercer_eslabon(2));

        prim_es.y1 = y_dim(tercer_eslabon(3), tercer_eslabon(1));
        prim_es.y2 = y_dim(tercer_eslabon(4), tercer_eslabon(2));

        prim_es.z1 = z_dim(tercer_eslabon(3), tercer_eslabon(1));
        prim_es.z2 = z_dim(tercer_eslabon(4), tercer_eslabon(2));

        a1 = [efec_fin.x1 efec_fin.y1 efec_fin.z1];
        a2 = [efec_fin.x2 efec_fin.y2 efec_fin.z2];

        b1 = [seg_es.x1 seg_es.y1 seg_es.z1];
        b2 = [seg_es.x2 seg_es.y2 seg_es.z2];

        c1 = [prim_es.x1 prim_es.y1 prim_es.z1];
        c2 = [prim_es.x2 prim_es.y2 prim_es.z2];

        center = origin;
        ef_finalPos = efec_fin.x1;
        line_1 = a1 - a2;
        line_2 = b1 - b2
        line_3 = c1 - c2;
        toc
        
    catch 
        disp('Error')
    end
end



%% Functions
function [c, f] = getCoordinates_V2(a,rows)
    c = ceil(a./rows);
    f = a - (rows*(c - 1));
end

function [c, f] = getCoordinates(a,rows)
    c = ceil(a./rows);
    f = a - (rows*(c - 1));
    
    c = round(mean(c));
    f = round(mean(f));
end


function A = RotX(t, p)
    A = [1 0 0; 0 cos(t) -sin(t); 0 sin(t) cos(t)]*p';
end

function A = RotY(t, p)
    A = [cos(t) 0 sin(t); 0 1 0; -sin(t) 0 cos(t)]*p';
end

function A = RotZ(t,p)
    A = [cos(t) -sin(t) 0; sin(t) cos(t) 0; 0 0 1]*p';
end

function band = colorFilter(colorImage, C, interestBand)
    n = find(~((colorImage(:,:,1) > (C.R - C.TH) & colorImage(:,:,1) < (C.R + C.TH) ...
              & colorImage(:,:,2) > (C.G - C.TH) & colorImage(:,:,2) < (C.G + C.TH)...
              & colorImage(:,:,3) > (C.B - C.TH) & colorImage(:,:,3) < (C.B + C.TH) )));

    br = colorImage(:,:,1);
    br(n) = 0;

    bv = colorImage(:,:,2);
    bv(n) = 0;

    ba = colorImage(:,:,3);
    ba(n) = 0;

    switch interestBand
        case 'R'
            band = br;
        case 'G'
            band = bv;
        case 'B'
            band = ba;
    end
end

function avg = getHoughTransform(band, FillGap, MinLength, type)
BW_A = edge(band,'canny');

[H,theta,rho] = hough(BW_A);
P = houghpeaks(H,5,'threshold',ceil(0.5*max(H(:))));
lines = houghlines(BW_A,theta,rho,P,'FillGap',FillGap,'MinLength',MinLength);
max_len = 0;
p1_avg = 0;
p2_avg = 0;
avg = 0;
    for k = 1:length(lines)
       xy = [lines(k).point1; lines(k).point2];
    %    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
        p1_avg = p1_avg + lines(k).point1;
        p2_avg = p2_avg + lines(k).point2;


    %    Plot beginnings and ends of lines
    %    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    %    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
       % Determine the endpoints of the longest line segment
       len = norm(lines(k).point1 - lines(k).point2);
       if ( len > max_len)
          max_len = len;
          xy_long = xy;
       end
    end
    % highlight the longest line segment
    p1_avg = round(p1_avg/length(lines));
    p2_avg = round(p2_avg/length(lines));
    
    switch type
        case 'AVG'
            avg = [p1_avg; p2_avg];
        case 'MAX'
            avg = xy_long;
    end
end

function initKinect()
    clear
    close all
    clc
    imaqreset;

    colorVid = imaq.VideoDevice('kinect',1);
    depthVid = imaq.VideoDevice('kinect',2);
    step(colorVid);
    step(depthVid);

end