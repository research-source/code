clc;

a=1.5;
T=[0,0];

LR=[-2.4,0;-2.6,0;-2.8,0];
RR=[2.4,0;2.6,0;2.8,0];

plot(T(1),T(2),'+');
hold on;

colorSpace=['g','b','r'];
lineStyle=['--','-'];
for i=1:3
    midPointL=(LR(i,:)+T)/2;
    midPointR = (RR(i,:)+T)/2;
    eccL=norm(LR(i,:)-T)/2/a;
    eccR=norm(RR(i,:)-T)/2/a;
    [elat,elon] = ellipse1(midPointL(1),midPointL(2),[a eccL]);   
    plot(elat,elon,'color',colorSpace(i));
    hold on;
    axis equal;
    plot(LR(i,1),LR(i,2),'*','color',colorSpace(i));
    hold on;
    [elat,elon] = ellipse1(midPointR(1),midPointR(2),[a eccR]);   
    plot(elat,elon,'color',colorSpace(i));
    hold on;
    axis equal;
    plot(RR(i,1),RR(i,2),'*','color',colorSpace(i));
    hold on;
end

La = zeros(1,40);
La(1) = 1.5;
new_a = a;
delta_a = 0:0.01:0.3;
midPoint2 = (LR(2,:)+T)/2;
ecc2 = norm(LR(2,:)-T)/2/a;
c2 = norm(LR(2,:)-T)/2;
midPoint1 = (LR(1,:)+T)/2;
ecc1 = norm(LR(1,:)-T)/2/a;
c1 = norm(LR(1,:)-T)/2;
[elat1,elon1] = ellipse1(midPoint1(1),midPoint1(2),[a ecc1]); 
[elat2,elon2] = ellipse1(midPoint2(1),midPoint2(2),[a ecc2]); 

for j = 1:39
    min = Inf;
    min_a = 0;
    for i=1:length(delta_a)
        temp_a = new_a+delta_a(i);
        ecc2=norm(LR(2,:)-T)/2/temp_a;
        [new_elat,new_elon] = ellipse1(midPoint2(1),midPoint2(2),  ...
            [temp_a ecc2]);
        
        %syms x y;
        %e1 = (x-midPoint1(1))^2/new_a^2+(y-midPoint1(2))^2/(new_a^2 - ... 
            %c1^2) - 1;
        %e2 = (x-midPoint2(1))^2/new_a^2+(y-midPoint1(2))^2/(new_a^2 - ... 
            %c1^2) - 1;
        %[x,y] = solve(e1,e2,x,y);
        %b = 0;
        %for k=1:length(y)
            %if y(k)>0
                %b = x(k);
                %break
            %end
        %end
        
        d = 0;
        num = 0;
        for k=1:length(new_elat)
            if elon1(k)>=0 && elat1(k)>midPoint1(1) && elat1(k)<0%elat1(k)>b && elat1(k)<0
                num = num + 1;
                d = d + sqrt((new_elat(k)-elat1(k))^2+(new_elon(k)-elon1(k))^2);
            end
        end
        if d/num < min
            min = d/num;
            min_a = temp_a;
        end
    end
    new_a = min_a;
    La(j+1) = min_a;
    ecc2 = norm(LR(2,:)-T)/2/new_a;
    ecc1 = norm(LR(1,:)-T)/2/new_a;
    [elat1,elon1] = ellipse1(midPoint1(1),midPoint1(2),[new_a ecc1]); 
    [elat2,elon2] = ellipse1(midPoint2(1),midPoint2(2),[new_a ecc2]);
    plot(elat1,elon1,'color',colorSpace(1));
    hold on;   
    plot(elat2,elon2,'--','color',colorSpace(2));
    hold on;
end

Ra = zeros(1,40);
Ra(1) = 1.5;
new_a = a;
delta_a = 0:0.01:0.3;
midPoint2 = (RR(2,:)+T)/2;
ecc2 = norm(RR(2,:)-T)/2/a;
c2 = norm(RR(2,:)-T)/2;
midPoint1 = (RR(1,:)+T)/2;
ecc1 = norm(RR(1,:)-T)/2/a;
c1 = norm(RR(1,:)-T)/2;
[elat1,elon1] = ellipse1(midPoint1(1),midPoint1(2),[a ecc1]); 
[elat2,elon2] = ellipse1(midPoint2(1),midPoint2(2),[a ecc2]); 

for j = 1:39
    j
    min = Inf;
    min_a = 0;
    for i=1:length(delta_a)
        temp_a = new_a+delta_a(i);
        ecc2=norm(RR(2,:)-T)/2/temp_a;
        [new_elat,new_elon] = ellipse1(midPoint2(1),midPoint2(2),  ...
            [temp_a ecc2]);
        
        %syms x y;
        %e1 = (x-midPoint1(1))^2/new_a^2+(y-midPoint1(2))^2/(new_a^2 - ... 
            %c1^2) - 1;
        %e2 = (x-midPoint2(1))^2/new_a^2+(y-midPoint1(2))^2/(new_a^2 - ... 
            %c1^2) - 1;
        %[x,y] = solve(e1,e2,x,y);
        %b = 0;
        %for k=1:length(y)
            %if y(k)>0
                %b = x(k);
                %break
            %end
        %end
        d = 0;
        num = 0;
        for k=1:length(new_elat)
            if elon1(k)>=0 && elat1(k)<midPoint1(1) && elat1(k)>0%&& elat1(k)<b && elat1(k)>0
                num = num + 1;
                d = d + sqrt((new_elat(k)-elat1(k))^2+(new_elon(k)-elon1(k))^2);
            end
        end
        if d/num < min
            min = d/num;
            min_a = temp_a;
        end
    end
    new_a = min_a;
    Ra(j+1) = min_a;
    ecc2 = norm(RR(2,:)-T)/2/new_a;
    ecc1 = norm(RR(1,:)-T)/2/new_a;
    [elat1,elon1] = ellipse1(midPoint1(1),midPoint1(2),[new_a ecc1]); 
    [elat2,elon2] = ellipse1(midPoint2(1),midPoint2(2),[new_a ecc2]);
    plot(elat1,elon1,'color',colorSpace(1));
    hold on;   
    plot(elat2,elon2,'--','color',colorSpace(2));
    hold on;
end