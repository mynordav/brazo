function [config, DH] = options_DK(config_in, DH_in)
    switch config_in
        case 'cartesian'
            config = 'ppp';
            DH     = [0,pi/2,3,0;0,pi/2,3,pi/2;0,0,3,0];
        case 'cylindrical'
            config ='rpp';
            DH     = [0,0,3,0;0,-pi/2,0,0;0,0,0,0];       
        otherwise
            config = config_in;
            DH     = DH_in;
    end
end