fred=zeros(240,320,3);  % initialize a 3-dimensional matrix of size 240x320x3
fgreen=zeros(240,320,3);
fblue=zeros(240,320,3);

while 1
    g=double(snapshot(cam))/255;
    f=g(1:2:end,1:2:end,:);		% reduce size by 2
        % now, f is of size 240 x 320 x 3
    subplot(2,2,1)
    image(f)
    subplot(2,2,2)
    fred(:,:,1)=f(:,:,1); % Only red is copied. Green & blue remain as 0.
    image(fred)
    fgreen(:,:,2)=f(:,:,2); % Only green is copied. Red & blue remain as 0.
    subplot(2,2,3)
    image(fgreen)
    fblue(:,:,3)=f(:,:,3); % Only blue is copied. Red & green remain as 0.
    subplot(2,2,4)
    image(fblue)
    drawnow
end
