g=ones(480,640,3);
y=double(imread('eiffel_tower.jpg'))/255;	% read a jpeg image of size 480(H)x640(W)

for k=1:1000,
    f=double(snapshot(cam))/255;
    f1 = f(1:240, 1:320, :);
    f2 = f(241:480, 1:320, :);
    f3 = f(1:240, 321:640, :);
    f4 = f(241:480, 321:640, :);
    c1 = squeeze(sum(sum(f1,1),2))/320/240;
    c2 = squeeze(sum(sum(f2,1),2))/320/240;
    c3 = squeeze(sum(sum(f3,1),2))/320/240;
    c4 = squeeze(sum(sum(f4,1),2))/320/240;
    
    
    g(1:240,1:320,1)=c1(1);
    g(1:240,1:320,2)=c1(2);
    g(1:240,1:320,3)=c1(3);	
    g(241:480,1:320,1)=c2(1);
    g(241:480,1:320,2)=c2(2);
    g(241:480,1:320,3)=c2(3);
    g(1:240,321:640,1)=c3(1);
    g(1:240,321:640,2)=c3(2);
    g(1:240,321:640,3)=c3(3);
    g(241:480,321:640,1)=c4(1);
    g(241:480,321:640,2)=c4(2);
    g(241:480,321:640,3)=c4(3);
    
    q=sum(abs(f-g),3);	% summation of the absolute difference over 3 colors
    I=(q>0.4);	% image of 0 or 1, 1 if the difference is bigger than threshold (0.2)
    J=1-I;	% image of 0 or 1, 1 if the difference is <= 0.2.
    
    f(:,:,1)=f(:,:,1).*I+y(:,:,1).*J;
    f(:,:,2)=f(:,:,2).*I+y(:,:,2).*J;
    f(:,:,3)=f(:,:,3).*I+y(:,:,3).*J;
    % now some part (where J is 1) of f is replaced by y
    image(f)
    drawnow
end
