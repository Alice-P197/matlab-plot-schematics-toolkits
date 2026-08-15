function plotApertureDisk(outerR, innerR, position, direction, color, thickness)
% 绘制带孔平面光阑
% 参数：
%   outerR    : 光阑外半径
%   innerR    : 孔径半径（0 < innerR < outerR）
%   position  : 中心位置 [x,y,z]
%   direction : 法线方向向量 [dx,dy,dz]
%   color     : 光阑颜色 [R,G,B]
%   thickness : 光阑厚度（建议0.1-1）

% 参数校验
if innerR >= outerR
    error('孔径必须小于外半径');
end
if numel(position)~=3 || numel(direction)~=3
    error('位置和方向必须为三维向量');
end

% 规范方向向量
direction = direction(:)/norm(direction);

% 生成带孔平面网格
theta = linspace(0, 2*pi, 50);
r = linspace(innerR, outerR, 20);
[T, R] = meshgrid(theta, r);
X = R .* cos(T);
Y = R .* sin(T);
Z = zeros(size(X))';

% 创建厚度维度
zLayers = linspace(-thickness/2, thickness/2, 3);
[~,~,Z] = meshgrid(theta, r, zLayers);
Z = permute(Z, [2 1 3])*thickness;

% 计算旋转矩阵
zAxis = [0;0;1];
if norm(direction - zAxis) < 1e-6
    R_mat = eye(3);
else
    rotAxis = cross(zAxis, direction);
    rotAngle = acos(dot(zAxis, direction));
    K = [0, -rotAxis(3), rotAxis(2);
         rotAxis(3), 0, -rotAxis(1);
         -rotAxis(2), rotAxis(1), 0];
    R_mat = eye(3) + sin(rotAngle)*K + (1-cos(rotAngle))*(K^2);
end

% 坐标变换
coords = [X(:), Y(:), Z(:)]';
rotated = R_mat * coords;
translated = rotated' + position;

% 重新整形坐标
X_new = reshape(translated(:,1), size(X));
Y_new = reshape(translated(:,2), size(Y));
Z_new = reshape(translated(:,3), size(Z));

% 创建银色材质
materialColor = color;
specParams = [0.8, 25, 0.9]; % [镜面强度, 高光指数, 反射率]

% 绘制光阑
figure
surf(X_new(:,:,1), Y_new(:,:,1), Z_new(:,:,1),...
    'FaceColor', materialColor,...
    'EdgeColor', 'none',...
    'FaceAlpha', 0.9,...
    'SpecularStrength', specParams(1),...
    'SpecularExponent', specParams(2),...
    'SpecularColorReflectance', specParams(3));
hold on

% 绘制侧面
for k = 1:size(Z_new,3)-1
    for j = 1:size(Z_new,2)
        patch([X_new(:,j,k); X_new(end:-1:1,j,k+1)],...
              [Y_new(:,j,k); Y_new(end:-1:1,j,k+1)],...
              [Z_new(:,j,k); Z_new(end:-1:1,j,k+1)],...
              materialColor, 'EdgeColor','none');
    end
end

% 绘制法线指示
arrowLen = outerR*1.2;
quiver3(position(1), position(2), position(3),...
        direction(1), direction(2), direction(3),...
        arrowLen, 'Color',[0.9 0.2 0.2], 'LineWidth',2,...
        'MaxHeadSize',0.3, 'AutoScale','off');

% 场景设置
axis equal
xlabel('X'), ylabel('Y'), zlabel('Z')
light('Position', position + direction*arrowLen*2, 'Style','local')
lighting gouraud
material metal
view(35,30)
grid on
title(sprintf('平面光阑\n外径: %.1f  孔径: %.1f', outerR, innerR))
end