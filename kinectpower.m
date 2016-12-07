%%
% colorVid = imaq.VideoDevice('kinect',1);
% depthVid = imaq.VideoDevice('kinect',2);
% step(colorVid);
% step(depthVid);
% 
% 
% figure(1);
% port = serial('COM9');
% port.BaudRate = 115200;
% fopen(port);

%%

string = 'sef999es999pe999ba999dir000\n';
while 1
    disp('-------------Iteracion---------------')
    tic
    colorImage = step(colorVid);
    depthImage = step(depthVid);
   
    ptCloud = pcfromkinect(depthVid, depthImage,colorImage);
    try
        
        out = detectColors(ptCloud);
        
        string = controlLaw2Raw(out);
        
    catch
        disp('Error')
        string = 'sef999es999pe999ba999dir000\n';
    end
    
    disp('----------------------------------------')
     %pause()
    fopen(port);
    fprintf(port, '%s', string);
    fclose(port);
    
    toc
end