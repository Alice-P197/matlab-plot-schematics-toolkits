function plotaxicon(X1,X2,r,color,alpha_2,text_coordinate,txt)
draw_axicon(X1,X2,r,color,alpha_2); hold on
direction = -X2+X1;h = 0.4*r;
amazing_cylinder(X1,direction,r,h,color,alpha_2);
text(text_coordinate(1),text_coordinate(2),text_coordinate(3),txt,'fontname','times new roman','fontsize',20)
end

function amazing_cylinder(position,direction,r,h,color,alpha)
% 规范方向向量
dirVec = direction(:)/norm(direction);
% 生成旋转矩阵
zAxis = [0; 0; 1];
if norm(dirVec - zAxis) < 1e-6
    R = eye(3);
else
    rotAxis = cross(zAxis, dirVec);
    rotAngle = acos(dot(zAxis, dirVec));
    K = [0, -rotAxis(3), rotAxis(2);
         rotAxis(3), 0, -rotAxis(1);
         -rotAxis(2), rotAxis(1), 0];
    R = eye(3) + sin(rotAngle)*K + (1-cos(rotAngle))*K^2;
end


% 表面纹理
[X_grid, Y_grid, Z_grid] = createCylinder(r,h);

% 坐标变换=================================================
% 变换主体
A = position;
B = position;
g = [position(1),position(2),position(3)+h]*R;
C = [g(1),g(2),g(3)];

  % 生成平面网格
[X_plane, Y_plane, Z_plane] = createDisk(r);
[Xb, Yb, Zb] = transformCoordinates(X_grid, Y_grid, Z_grid, R, A);
[Xp, Yp, Zp] = transformCoordinates(X_plane, Y_plane, Z_plane, R, B);
[Xc, Yc, Zc] = transformCoordinates(X_plane, Y_plane, Z_plane+h, R, B);

hold on;
surf(Xp, Yp, Zp,'FaceColor', color, 'EdgeColor', 'none','FaceAlpha',alpha);
surf(Xc, Yc, Zc,'FaceColor', color, 'EdgeColor', 'none','FaceAlpha',alpha);
surf(Xb, Yb, Zb,'FaceColor', color, 'EdgeColor', 'none','FaceAlpha',alpha);
axis equal
view(3)
end
function [X,Y,Z] = createCylinder(r, h)
% 生成圆柱体
theta = linspace(0, 2*pi, 200); z = linspace(0, h, 200);
[Theta, Z] = meshgrid(theta, z);
X = r * cos(Theta);
Y = r * sin(Theta);
end

function [X_new, Y_new, Z_new] = transformCoordinates(X, Y, Z, R, position)
% 坐标变换（复用之前版本）
coords = [X(:), Y(:), Z(:)]';
rotated = R * coords;
translated = rotated' + position;
X_new = reshape(translated(:,1), size(X));
Y_new = reshape(translated(:,2), size(Y));
Z_new = reshape(translated(:,3), size(Z));
end

function [X, Y, Z] = createDisk(radius)
    theta = linspace(0, 2*pi, 200);
    r = linspace(0, radius, 200);
    [Theta, R] = meshgrid(theta, r);
    X = R .* cos(Theta);
    Y = R .* sin(Theta);
    Z = zeros(size(X));
end