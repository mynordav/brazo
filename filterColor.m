function V = filterColor(hsvImg, h, thH, thS, thV)
    
    
    H = hsvImg(:,:,1);  S = hsvImg(:,:,2);  V = hsvImg(:,:,3);
    V(S < thS) = 0;
    V(V < thV) = 0;
    V(abs(H - h) > thH) = 0;
    V(V>0) = 1;
    
    %hsvImg(:,:,3) = V;
    
    %imgOut = hsv2rgb(hsvImg);
    
end