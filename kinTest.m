clear all
clc
imaqreset;

C1 = struct('R',  35, 'G',  95, 'B', 120, 'TH', 40);        %azul
C2 = struct('R',  50, 'G', 130, 'B', 150, 'TH', 40);        %rosa
C3 = struct('R', 130, 'G', 155, 'B',  60, 'TH', 15);        %azul(hoja)

colorVid = imaq.VideoDevice('kinect',1);
depthVid = imaq.VideoDevice('kinect',2);
step(colorVid);
step(depthVid);

colorImage = step(colorVid);
depthImage = step(depthVid);

ptCloud = pcfromkinect(depthVid, depthImage,colorImage);
tic
n = find(~((colorImage(:,:,1) > uint8(C2.R - C2.TH) & colorImage(:,:,1) < uint8(C2.R + C2.TH) ...
          & colorImage(:,:,2) > uint8(C2.G - C2.TH) & colorImage(:,:,2) < uint8(C2.G + C2.TH)...
          & colorImage(:,:,3) > uint8(C2.B - C2.TH) & colorImage(:,:,3) < uint8(C2.B + C2.TH) )));
      
br = colorImage(:,:,1);
br(n) = 0;

bv = colorImage(:,:,2);
bv(n) = 0;

ba = colorImage(:,:,3);
ba(n) = 0;

a(:,:,1) = br;
a (:,:,2) = bv;
a (:,:,3) = ba;


%compute Hough Transform
BW = edge(ba,'canny');
% figure(2)
% imshow(BW);
[H,theta,rho] = hough(BW);
P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
lines = houghlines(BW,theta,rho,P,'FillGap',20,'MinLength',10);

figure(1), imshow(ba), hold on
max_len = 0;

for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   %plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   %plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   %plot(xy(2,1),xy(2,2),'x','Lixy_long()neWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');
toc
ptCloud.Location(xy_long(1),xy_long(3),:)

