%%
% colorVid = imaq.VideoDevice('kinect',1);
% depthVid = imaq.VideoDevice('kinect',2);
% step(colorVid);
% step(depthVid);

%%
figure(1);


while 1
    tic
    colorImage = step(colorVid);
    depthImage = step(depthVid);
   
    ptCloud = pcfromkinect(depthVid, depthImage,colorImage);
    try
        
        out = detectColors(ptCloud);
        
        string = controlLaw2Raw(out);
    catch
        disp('Error')
    end
    toc
end