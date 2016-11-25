clear
clc

port = serial('COM7');
port.BaudRate = 115200;
port.Terminator = 'CR/LF';
%fopen(port);


while 1
   try
        s = 'sef500se500pe900ba7001100\n'
        fopen(port);
        fprintf(port, '%s', s);
        %   b = fscanf(port)
        fclose(port);
        pause(0.3)
        s = 'sef500se500pe900ba7000000\n'
        fopen(port);
        fprintf(port, '%s', s);
       % b = fscanf(port)
        fclose(port);
        pause(0.3)
    catch
        fclose(port);
        s;
    end
end

    

fclose(port);
