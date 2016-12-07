%%
colorVid = imaq.VideoDevice('kinect',1);
depthVid = imaq.VideoDevice('kinect',2);
step(colorVid);
step(depthVid);
%%

port = serial('COM9');
port.BaudRate = 115200;

%%
string = 'sef999es999pe999ba999dir0001\n';

fopen(port);
fprintf(port, '%s', string);
fclose(port);
