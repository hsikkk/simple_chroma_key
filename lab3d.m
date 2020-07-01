function lab3d(cam)
% Try to place your eyes in the white box and click "Record" button at the bottom of the figure.
% Move your eyes and see if a black box follows your eyes.
% Written by Sae-Young Chung, 2015
% Last update: 2016/3/17

f=double(snapshot(cam))/255;
image(f);
drawnow     % do this such that the pushbutton defined below appears

% The following creates a button with "Record" written on it.
% If you click the "Record" button, "pushbutton1_Callback" function (see below) is called.
h1=uicontrol('Style','pushbutton','String','Record','Position',[280 10 50 30],'Callback',@pushbutton1_Callback);

e=0;    % this will change to 1 by the pushbutton1_Callback function when "Record" button is pressed
y1=101; % coordinates for the white box for capturing template
y2=151;
x1=121;
x2=181;

y3 = 101;
y4 = 151;
x3 = 240;
x4 = 300;

while 1
    f=double(snapshot(cam))/255;
    %f=f(:,640:-1:1,:);      % flip left & right to make it look like a mirror
    g=f;
    g(y1:y1+1,x1:x2,:)=1;   % draw a white bounding box
    g(y2-1:y2,x1:x2,:)=1;
    g(y1:y2,x1:x1+1,:)=1;
    g(y1:y2,x2-1:x2,:)=1;
    g(y3:y3+1,x3:x4,:)=1;   % draw a white bounding box
    g(y4-1:y4,x3:x4,:)=1;
    g(y3:y4,x3:x3+1,:)=1;
    g(y3:y4,x4-1:x4,:)=1;
    image(g);
    drawnow
    if e    % if you click "Record" button, the call back function "pushbutton1_Callback" will set e=1 and the code inside this 'if' statement will run.
        template1=f(y1+1:y2,x1+1:x2,:);
        template2=f(y3+1:y4,x3+1:x4,:);% generate 'template' matrix from 'f'. This will contain a part of the image and will be used as a template for pattern recognition.
        break;
    end
end

revtemplate1=template1(50:-1:1,60:-1:1,:); % will contain the template in reverse order, which is needed for the 2-dimensional convolution do be done later.
revtemplate2=template2(50:-1:1,60:-1:1,:); 

h1=zeros(151,451); % initialize a matrix that will contain the result of a 2D convolution. See below why this size is 161 by 81.
h2=zeros(151,451);
nt=ones(50,60);    % all one template for computing the norm of the image 'g'
hn1=zeros(151,451);% initialize a matrix that will contain the result of a 2D convolution.
hn2=zeros(151,451);

while 1
    f=double(snapshot(cam))/255;
    %f=f(:,640:-1:1,:);      % flip left & right to make it look like a mirror
    g=f(101:300,81:560,:); % we only do convolution for a small area of 'f' to make this fast
    g2=g.^2;    % square each element of g
    h1=conv2(g(:,:,1),revtemplate1(:,:,1),'valid');    % 2-dim convolution for red color.
    h1=h1+conv2(g(:,:,2),revtemplate1(:,:,2),'valid');    % green
    h1=h1+conv2(g(:,:,3),revtemplate1(:,:,3),'valid');    % blue

    h2=conv2(g(:,:,1),revtemplate2(:,:,1),'valid');    % 2-dim convolution for red color.
    h2=h2+conv2(g(:,:,2),revtemplate2(:,:,2),'valid');    % green
    h2=h2+conv2(g(:,:,3),revtemplate2(:,:,3),'valid');    % blue
        % Note that there are many inner product values you needed to calculate,
        % i.e., one inner product value for each 40*160 area of the image 'g'.
        % We are using 2-dim convolution between g and revtemplate for calculating many inner product values simultaneously,
        % which would be faster than doing the same calculation using double 'for' loops.
        % Note that 'valid' option in conv2() will perform the convolution
        % such that the output values contain only those fully overlapped
        % parts. For example, conv([1 2 3 4],[1 1]) will give [1 3 5 7 4],
        % but conv([1 2 3 4],[1 1],'valid') will give [3 5 7] since the
        % first and last outputs in [1 3 5 7 4] are from partial overlapping
        % between [1 2 3 4] and [1 1].
        % Since the size of g is 200 by 240 and the size of revtemplate is
        % 40 by 160, the result of the 2-dim convolution with 'valid'
        % option becomes 161 by 81.
    
    hn1=conv2(g2(:,:,1),nt,'valid');  % 2-dim convolution for red color. This is for calculating the squared norm of g
    hn1=hn1+conv2(g2(:,:,2),nt,'valid');  % for green color
    hn1=hn1+conv2(g2(:,:,3),nt,'valid');  % for blue color

    hn2=conv2(g2(:,:,1),nt,'valid');  % 2-dim convolution for red color. This is for calculating the squared norm of g
    hn2=hn2+conv2(g2(:,:,2),nt,'valid');  % for green color
    hn2=hn2+conv2(g2(:,:,3),nt,'valid');  % for blue color
        % Note that there are many norm values you needed to calculate,
        % i.e., one norm value for each 40*160 area of the image 'g'.
        % We are using 2-dim convolution between g2 and nt for calculating many squared norm values simultaneously,
        % which would be faster than doing the same calculation using double 'for' loops.
    
    h1=h1.^2./hn1;  % normalization by squared norm of g
    h2=h2.^2./hn2;
    t1=reshape(h1,151*421,1);	% reshape 161 by 81 matrix h to a column vector of length 161*81
    t2=reshape(h2,151*421,1);
    [m1,i1]=max(t1);	% find the maximum (m) of t and its index (i)
    [m2,i2]=max(t2);
        % Note that the above line is the key step, i.e., it finds where
        % the maximum inner product (normalized by norm of g) happens in the image 'g'.
        % (To be precise, the square of inner product is normalized by the squared norm
        % of g. But it does not matter for us since we only need to find
        % where the maximum occurs.)
    
    x1=floor((i1-1)/151)+1;  % calculate x and y coordinates where the maximum occurred
    y1=mod(i1-1,151)+1;
    x2=floor((i2-1)/151)+1;  % calculate x and y coordinates where the maximum occurred
    y2=mod(i2-1,151)+1;

    D=zeros(480,640,3);
    D(:, :, :) = 0.4;
    D(y1+100:y1+149,x1+80:x1+139,:)=1;
    D(y2+100:y2+149,x2+80:x2+139,:)=1; 
        % If x==1 and y==1, it means the detected pattern starts at (101,201).
        % So, this is why we do y+100 and x+200 for the upper left starting
        % point. Since the size of the detection area is 40 by 160, the
        % lower right ending point is given by y+139 and x+359.
    f = f.*D;
    f([98:100 301:303],78:563,:)=1;   % draw a white bounding box
    f(98:303,[78:80 561:563],:)=1;
    f(y1+160:y1+180,x1+80:x1+139,:)=1;
    f(y2+160:y2+180,x2+80:x2+139,:)=1;
    image(f);

    h1 = text(x1+85, y1+170,'People1');
    set(h1, 'Color', [0 0 0]);
    set(h1, 'FontSize', [5]);
    set(h1,'HorizontalAlignment','left')
    set(h1,'LineWidth',[3])

    h2 = text(x2+85, y2+170,'People2');
    set(h2, 'Color', [0 0 0]);
    set(h2, 'FontSize', [5]);
    set(h2,'HorizontalAlignment','left')
    set(h2,'LineWidth',[3])


    drawnow
end

function pushbutton1_Callback(hObject, eventdata, handles) 
    % this is called when you press the Record button
e = 1;
end
end
