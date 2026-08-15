function plotFlatAperture(outerR, innerR, position, direction, color,text_X,txt)
% 绘制二维平面光阑（中间带圆孔）
% 参数：
%   outerR    : 光阑外半径
%   innerR    : 孔径半径 (0 < innerR < outerR)
%   position  : 中心位置 [x,y,z]
%   direction : 法线方向向量 [dx,dy,dz]
%   color     : 光阑颜色 [R,G,B]

% 参数校验
if innerR >= outerR
    error('孔径必须小于外半径');
end
direction = direction/norm(direction);

% 生成环形网格
theta = linspace(0, 2*pi, 100);
r = linspace(innerR, outerR, 50);
[Theta, R] = meshgrid(theta, r);

% 平面坐标
X = R .* cos(Theta);
Y = R .* sin(Theta);
Z = zeros(size(X)); % 保持二维平面

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

% 重新整形
X_new = reshape(translated(:,1), size(X));
Y_new = reshape(translated(:,2), size(Y));
Z_new = reshape(translated(:,3), size(Z));

% 创建银色材质
materialColor = color;
specParams = [0.8, 50, 0.9]; % [镜面强度, 高光指数, 反射率]

% 绘制光阑
surf(X_new, Y_new, Z_new,...
    'FaceColor', materialColor,...
    'EdgeColor', 'none',...
    'FaceAlpha', 0.95,...
    'AmbientStrength', 0.3,...
    'DiffuseStrength', 0.6,...
    'SpecularStrength', specParams(1),...
    'SpecularExponent', specParams(2),...
    'SpecularColorReflectance', specParams(3));

% 添加边缘高光
hold on
plot3(X_new(1,:), Y_new(1,:), Z_new(1,:),... % 外边缘
    'Color', [1 1 1]*0.9, 'LineWidth', 1.5);
plot3(X_new(end,:), Y_new(end,:), Z_new(end,:),... % 内边缘
    'Color', [1 1 1]*0.9, 'LineWidth', 1.5);

% 法线指示
quiver3(position(1), position(2), position(3),...
        direction(1), direction(2), direction(3),...
        outerR*1.2, 'r', 'LineWidth', 2,...
        'MaxHeadSize', 0.3, 'AutoScale', 'off');

% 场景设置
axis equal tight
xlabel('X'), ylabel('Y'), zlabel('Z')
text(text_X(1),text_X(2),text_X(3),txt,'Fontname','times new roman','fontsize',20)
material metal
end