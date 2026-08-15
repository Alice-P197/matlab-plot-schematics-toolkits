function Quiver3(u1,u2,color_a,color_p,r,alpha_1,alpha_2)
%% 给定任意两点绘制3D箭头
%% u1是起始坐标
%5 u2箭头坐标
%% color_a 箭头颜色
%% color_p 箭身颜色
%% r 箭头半径
%% alpha_1 箭头明度
%% alpha_2 箭身明度
    x0 = u1(1);y0 = u1(2); z0 = u1(3);
    x1 = u2(1);y1 = u2(2); z1 = u2(3);
    L = sqrt((x1-x0)^2+(y1-y0)^2+(z1-z0)^2);d = 0.2*L;
    x3 = x1-d*(x1-x0)/L; y3 = y1-d*(y1-y0)/L;z3 = z1-d*(z1-z0)/L;
    u3 = [x3,y3,z3];
    cylinder3(u1,u3,r,color_a,alpha_1)
    hold on
    cone3(u3,u2,r*(1+0.5),color_p,alpha_2)
    
    % 画出箭身
    function cylinder3(X1,X2,r,color,alpha_1)
        %一个简单的例子：cylinder3([1 2 3],[7 8 9],2,'b')；两个空间点位置，半径，颜色
        length_cyl=norm(X2-X1);
        [x,y,z]=cylinder(r,100);
        z=z*length_cyl;
        %绘制两个底面
        hold on;
        EndPlate1=fill3(x(1,:),y(1,:),z(1,:),'r');
        EndPlate2=fill3(x(2,:),y(2,:),z(2,:),'r');
        Cylinder=mesh(x,y,z);
        %计算圆柱体旋转的角度
        unit_V=[0 0 1];
        angle_X1X2=acos(dot( unit_V,(X2-X1) )/( norm(unit_V)*norm(X2-X1)) )*180/pi;
        %计算旋转轴
        if angle_X1X2==180
            axis_rot=[1 0 0];
        else
            axis_rot=cross(unit_V,(X2-X1));
        end
        %将圆柱体旋转到期望方向
        if angle_X1X2~=0 % Rotation is not needed if required direction is along X
            rotate(Cylinder,axis_rot,angle_X1X2,[0 0 0])
            rotate(EndPlate1,axis_rot,angle_X1X2,[0 0 0])
            rotate(EndPlate2,axis_rot,angle_X1X2,[0 0 0])
        end
        %将圆柱体和平面挪到期望的位置
        set(EndPlate1,'XData',get(EndPlate1,'XData')+X1(1))
        set(EndPlate1,'YData',get(EndPlate1,'YData')+X1(2))
        set(EndPlate1,'ZData',get(EndPlate1,'ZData')+X1(3))
        set(EndPlate2,'XData',get(EndPlate2,'XData')+X1(1))
        set(EndPlate2,'YData',get(EndPlate2,'YData')+X1(2))
        set(EndPlate2,'ZData',get(EndPlate2,'ZData')+X1(3))
        set(Cylinder,'XData',get(Cylinder,'XData')+X1(1))
        set(Cylinder,'YData',get(Cylinder,'YData')+X1(2))
        set(Cylinder,'ZData',get(Cylinder,'ZData')+X1(3))
        % 设置圆柱体的颜色
        set(Cylinder,'FaceColor',color,'FaceAlpha',alpha_1)
        set([EndPlate1 EndPlate2],'FaceColor',color)
        set(Cylinder,'EdgeAlpha',0)
        set([EndPlate1 EndPlate2],'EdgeAlpha',0)
        axis equal;
        view(3)
    end
    
    % 画箭头 
    function cone3(X1,X2,r,color,alpha_2)
        %一个简单的例子：cone3([1 2 3],[7 8 9],1,'b');%两个空间点位置，圆锥底面半径，颜色
        % 圆锥的高度
        length_cyl=norm(X2-X1);
        [x,y,z]=cylinder(linspace(r,0,50),100);
        z=z*length_cyl;
        %绘制圆锥底面
        hold on;
        EndPlate1=fill3(x(1,:),y(1,:),z(1,:),'r');
        Cylinder=mesh(x,y,z);
        %计算圆锥体旋转的角度
        unit_V=[0 0 1];
        angle_X1X2=acos(dot( unit_V,(X2-X1) )/( norm(unit_V)*norm(X2-X1)) )*180/pi;
        %计算旋转轴
        axis_rot=cross(unit_V,(X2-X1));
        %将圆锥体旋转到期望方向
        if angle_X1X2~=0 % Rotation is not needed if required direction is along X
            rotate(Cylinder,axis_rot,angle_X1X2,[0 0 0])
            rotate(EndPlate1,axis_rot,angle_X1X2,[0 0 0])
        end
        %将圆锥体和底面挪到期望的位置
        set(EndPlate1,'XData',get(EndPlate1,'XData')+X1(1))
        set(EndPlate1,'YData',get(EndPlate1,'YData')+X1(2))
        set(EndPlate1,'ZData',get(EndPlate1,'ZData')+X1(3))
        set(Cylinder,'XData',get(Cylinder,'XData')+X1(1))
        set(Cylinder,'YData',get(Cylinder,'YData')+X1(2))
        set(Cylinder,'ZData',get(Cylinder,'ZData')+X1(3))
        % 设置圆锥体的颜色
        set(Cylinder,'FaceColor',color)
        set(EndPlate1,'FaceColor',color)
        set(Cylinder,'EdgeAlpha',0)
        set(EndPlate1,'EdgeAlpha',0)
        set(Cylinder,'FaceAlpha',alpha_2)
        set(EndPlate1,'FaceAlpha',alpha_2)
        axis equal;
    end
end