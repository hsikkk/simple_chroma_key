d=100;
while 1
    f=double(snapshot(cam))/255;
    f1=f(241-d/2:240+d/2,161-d/2:160+d/2,2);
        % d * d image (left). Take only the green color
    f2=f(241-d/2:240+d/2,481-d/2:480+d/2,2);
        % d * d image (right). Take only the green color
    f1_f2_inner_prod = sum(dot(f1,f2));
    f1_norm = norm(f1);
    f2_norm = norm(f2);
    
    r = f1_f2_inner_prod / f1_norm / f2_norm;
    c=[1 0 0];	% color of bounding boxes (red)
    
    for i=1:3   % draw bounding boxes
        f(238-d/2:243+d/2,[(158:160)-d/2 (161:163)+d/2],i)=c(i);
        f([(238:240)-d/2 (241:243)+d/2],158-d/2:163+d/2,i)=c(i);
        f(238-d/2:243+d/2,[(158:160)-d/2 (161:163)+d/2]+320,i)=c(i);
        f([(238:240)-d/2 (241:243)+d/2],(158-d/2:163+d/2)+320,i)=c(i);
    end
    
    image(f)
    ht=text(320,100,sprintf('angle = %d', round(180/pi*acos(r))));
    set(ht,'LineWidth',[3])
    set(ht,'FontSize',[30])
    set(ht,'Color',[1 0 0])
    set(ht,'HorizontalAlignment','center')
    drawnow
end
