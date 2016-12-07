%%
% port = serial('COM7');
% port.BaudRate = 115200;
% port.Terminator = 'LF';

%%
i = 50;
while 1
    pause(1)
string = ' sef100es200pe300ba400dir0000\n';
fopen(port);
fprintf(port, '%s', string)
%f = fscanf(port)
fclose(port);
i = i+1;
end