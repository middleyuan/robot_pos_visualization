%%
run('C:\Program Files\MATLAB\R2016a\toolbox\rvctools\startup_rvc.m')
%%
mbed = serial('COM9', ...
                  'BaudRate', 230400, ...
                  'Parity', 'none', ...
                  'DataBits', 8, ...
                  'StopBits', 1);
 %%
fopen(mbed);
%%
while(1)
    uart_read = fscanf(mbed,'%f,%f,%f,%f,%f,%d,%d\r\n')
end
%%
d = 0.5;
l = 0.25;
lb = 0.1;
a = 0.4;
a2 = 0.55;
theta_y = pi/2; % yaw angle
body_0 = [0 0 0]; % oringin
theta_p = 0;
theta_p2 = -pi/8;
theta_y2 = pi/10;
theta_p3 = 0;
theta_y3 = 0;
theta_e = 0;
theta_e2 = 0;
COM = [-d*sin(theta_p) 0 d*cos(theta_p)]; % ceter of mass
RS = COM + [0 l 0];
LS = COM + [0 -l 0];
RB = [0 lb 0];
LB = [0 -lb 0];
RK = RB + [a*sin(theta_p2) a*sin(theta_y2)*cos(theta_p2) -a*cos(theta_y2)*cos(theta_p2)];
LK = LB + [a*sin(theta_p3) a*sin(theta_y3)*cos(theta_p3) -a*cos(theta_y3)*cos(theta_p3)];
RF = RB + [a*sin(theta_p2)+a2*sin(theta_p2+theta_e) sin(theta_y2)*(a*cos(theta_p2)+a2*cos(theta_p2+theta_e)) -cos(theta_y2)*(a2*cos(theta_p2+theta_e)+a*cos(theta_p2))];
LF = LB + [a*sin(theta_p3)+a2*sin(theta_p3+theta_e2) sin(theta_y3)*(a*cos(theta_p3)+a2*cos(theta_p3+theta_e2)) -cos(theta_y3)*(a2*cos(theta_p3+theta_e2)+a*cos(theta_p3))];
pts = [RB; LB];
pts1 = [RB; LS];
pts2 = [LB; RS];
pts3 = [RS; LS];
pts4 = [body_0; COM];
pts5 = [RB; RK];
pts6 = [LB; LK];
pts7 = [RK; RF];
pts8 = [LK; LF];
axis([-1 1 -1 1 -1 1]);
xlabel('x');ylabel('y');zlabel('z');
hold on;
grid on;
h1 = plot3(pts(:,1), pts(:,2), pts(:,3),'linewidth',3,'color',[0.4 0.6 0.7]);
h4 = plot3(pts3(:,1), pts3(:,2), pts3(:,3),'linewidth',3,'color',[0.4 0.6 0.7]);
h5 = plot3(pts2(:,1), pts2(:,2), pts2(:,3),'linewidth',3,'color',[0.4 0.6 0.7]);
h6 = plot3(pts1(:,1), pts1(:,2), pts1(:,3),'linewidth',3,'color',[0.4 0.6 0.7]);
h8 = plot3(pts5(:,1), pts5(:,2), pts5(:,3),'linewidth',3,'color',[0.4 0.6 0.7]);
h9 = plot3(pts6(:,1), pts6(:,2), pts6(:,3),'linewidth',3,'color',[0.4 0.6 0.7]);
h10 = plot3(pts7(:,1), pts7(:,2), pts7(:,3),'linewidth',3,'color',[0.4 0.6 0.7]);
h16 = plot3(pts8(:,1), pts8(:,2), pts8(:,3),'linewidth',3,'color',[0.4 0.6 0.7]);
h2 = plot3(-d*sin(theta_p), 0, d*cos(theta_p)-0.16,'o','MarkerFaceColor',[1 0.3 0.1],'MarkerEdgeColor',[1 0.3 0.1],'MarkerSize',18);
h3 = plot3(-d*sin(theta_p), l, d*cos(theta_p),'o','MarkerFaceColor','b','MarkerEdgeColor','k','MarkerSize',10);
h7 = plot3(-d*sin(theta_p), -l, d*cos(theta_p),'o','MarkerFaceColor','b','MarkerEdgeColor','k','MarkerSize',10);
h11 = plot3(0, lb, 0,'o','MarkerFaceColor','b','MarkerEdgeColor','k','MarkerSize',8);
h12 = plot3(0, -lb, 0,'o','MarkerFaceColor','b','MarkerEdgeColor','k','MarkerSize',8);
h13 = plot3(a*sin(theta_p2), a*sin(theta_y2)*cos(theta_p2)+lb, -a*cos(theta_y2)*cos(theta_p2),'o','MarkerFaceColor','b','MarkerEdgeColor','k','MarkerSize',8);
h14 = plot3(a*sin(theta_p3), a*sin(theta_y3)*cos(theta_p3)-lb, -a*cos(theta_y3)*cos(theta_p3),'o','MarkerFaceColor','b','MarkerEdgeColor','k','MarkerSize',8);
h15 = plot3(a*sin(theta_p2)+a2*sin(theta_p2+theta_e), sin(theta_y2)*(a*cos(theta_p2)+a2*cos(theta_p2+theta_e))+lb, -cos(theta_y2)*(a2*cos(theta_p2+theta_e)+a*cos(theta_p2)),'^','MarkerFaceColor','b','MarkerEdgeColor','k','MarkerSize',10);
h17 = plot3(a*sin(theta_p3)+a2*sin(theta_p3+theta_e2), sin(theta_y3)*(a*cos(theta_p3)+a2*cos(theta_p3+theta_e2))-lb, -cos(theta_y3)*(a2*cos(theta_p3+theta_e2)+a*cos(theta_p3)),'^','MarkerFaceColor','b','MarkerEdgeColor','k','MarkerSize',10);
%%
while(1)
uart_read = fscanf(mbed,'%f,%f,%f,%f,%f,%d,%d\r\n');
theta_p = uart_read(1)*pi/180; % pitch angle
theta_p2 = uart_read(2)*pi/180;
theta_y2 = uart_read(3)*pi/180;
theta_p3 = uart_read(4)*pi/180;
theta_y3 = uart_read(5)*pi/180;
%theta_e = -uart_read(6)*pi/180;
if (uart_read(7) > 300)
    uart_read(7) = uart_read(7) -360;
end
theta_e2 = (((uart_read(7)-240)/4.5*pi/180)+pi/2.8)
COM = [-d*sin(theta_p) 0 d*cos(theta_p)]; % ceter of mass
RS = COM + [0 l 0];
LS = COM + [0 -l 0];
RK = RB + [a*sin(theta_p2) a*sin(theta_y2)*cos(theta_p2) -a*cos(theta_y2)*cos(theta_p2)];
LK = LB + [a*sin(theta_p3) a*sin(theta_y3)*cos(theta_p3) -a*cos(theta_y3)*cos(theta_p3)];
RF = RB + [a*sin(theta_p2)+a2*sin(theta_p2+theta_e) sin(theta_y2)*(a*cos(theta_p2)+a2*cos(theta_p2+theta_e)) -cos(theta_y2)*(a2*cos(theta_p2+theta_e)+a*cos(theta_p2))];
LF = LB + [a*sin(theta_p3)+a2*sin(theta_p3+theta_e2) sin(theta_y3)*(a*cos(theta_p3)+a2*cos(theta_p3+theta_e2)) -cos(theta_y3)*(a2*cos(theta_p3+theta_e2)+a*cos(theta_p3))];
pts7 = [RK; RF];
pts = [RB; LB];
pts1 = [RB; LS];
pts2 = [LB; RS];
pts3 = [RS; LS];
pts4 = [body_0; COM];
pts5 = [RB; RK];
pts6 = [LB; LK];
pts8 = [LK; LF];
set(h1, 'XData', pts(:,1), 'YData', pts(:,2), 'ZData', pts(:,3));
set(h8, 'XData', pts5(:,1), 'YData', pts5(:,2), 'ZData', pts5(:,3));
set(h9, 'XData', pts6(:,1), 'YData', pts6(:,2), 'ZData', pts6(:,3));
set(h10, 'XData', pts7(:,1), 'YData', pts7(:,2), 'ZData', pts7(:,3));
set(h4, 'XData', pts3(:,1), 'YData', pts3(:,2), 'ZData', pts3(:,3));
set(h5, 'XData', pts2(:,1), 'YData', pts2(:,2), 'ZData', pts2(:,3));
set(h6, 'XData', pts1(:,1), 'YData', pts1(:,2), 'ZData', pts1(:,3));
set(h16, 'XData', pts8(:,1), 'YData', pts8(:,2), 'ZData', pts8(:,3));
set(h2, 'XData', -d*sin(theta_p), 'YData', 0, 'ZData', d*cos(theta_p)-0.16);
set(h3, 'XData', -d*sin(theta_p), 'YData', l, 'ZData', d*cos(theta_p));
set(h7, 'XData', -d*sin(theta_p), 'YData', -l, 'ZData', d*cos(theta_p));
set(h11, 'XData', 0, 'YData', lb, 'ZData', 0);
set(h12, 'XData', 0, 'YData', -lb, 'ZData', 0);
set(h13, 'XData', a*sin(theta_p2), 'YData', a*sin(theta_y2)*cos(theta_p2)+lb, 'ZData', -a*cos(theta_y2)*cos(theta_p2));
set(h14, 'XData', a*sin(theta_p3), 'YData', a*sin(theta_y3)*cos(theta_p3)-lb, 'ZData', -a*cos(theta_y3)*cos(theta_p3));
set(h15, 'XData', a*sin(theta_p2)+a2*sin(theta_p2+theta_e), 'YData', sin(theta_y2)*(a*cos(theta_p2)+a2*cos(theta_p2+theta_e))+lb, 'ZData', -cos(theta_y2)*(a2*cos(theta_p2+theta_e)+a*cos(theta_p2)));
set(h17, 'XData', a*sin(theta_p3)+a2*sin(theta_p3+theta_e2), 'YData', sin(theta_y3)*(a*cos(theta_p3)+a2*cos(theta_p3+theta_e2))-lb, 'ZData', -cos(theta_y3)*(a2*cos(theta_p3+theta_e2)+a*cos(theta_p3)));
drawnow;
end

%%
fclose(mbed);
%%
i = 0;
while(1)
    i = i + 1;
    uart_read = fscanf(mbed,'%f,%f,%f,%f,%f,%d,%d\r\n')
    theta_p(i) = uart_read(1); % pitch angle
    theta_p2(i) = uart_read(2);
    theta_y2(i) = uart_read(3);
    theta_p3(i) = uart_read(4);
    theta_y3(i) = uart_read(5);
    theta_e(i) = uart_read(6);
    theta_e2(i) = uart_read(7);
    subplot(4,2,1);  % real time plot
    plot(theta_p(i));
    subplot(4,2,2);
    plot(theta_p2(i));
    subplot(4,2,3);
    plot(theta_y2(i));
    subplot(4,2,4);
    plot(theta_p3(i));
    subplot(4,2,5);
    plot(theta_y3(i));
    subplot(4,2,6);
    plot(theta_e(i));
    subplot(4,2,7);
    plot(theta_e2(i));
    drawnow;
end
%%
fclose(mbed);