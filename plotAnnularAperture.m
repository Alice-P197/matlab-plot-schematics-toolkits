function plotAnnularAperture(R, r, position, direction, thickness)
% 绘制三维环形光阑（立体银边）
% 参数：
%   R        : 环形主半径（中心到管中线距离）
%   r        : 环形管半径（截面半径）
%   position : 中心位置 [x,y,z]
%   direction: 法线方向向量 [dx,dy,dz]
%   thickness: 边缘厚度系数（0-1）

% 参数校验
if numel(position)~=3 || numel(direction)~=3
    error('位置和方向必须为三维向量');
end
direction = direction(:)/norm(direction); % 归一化方向向量

% 生成圆环参数化网格
[u,v] = meshgrid(linspace(0,2*pi,50), linspace(0,2*pi,30));
X = (R + r*cos(v)) .* cos(u);
Y = (R + r*cos(v)) .* sin(u);
Z = r*sin(v);

% 添加厚度渐变（根据厚度系数）
thicknessProfile = 1 - thickness*abs(sin(v/2));
X = X .* thicknessProfile;
Y = Y .* thicknessProfile;
Z = Z .* thicknessProfile;

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
silverColor = [0.8 0.8 0.8];  % RGB颜色
specularStrength = 0.2;        % 镜面反射强度
specularExponent = 15;         % 高光指数

% 绘制光阑
surf(X_new, Y_new, Z_new,...
    'FaceColor', silverColor,...
    'EdgeColor', 'none',...
    'FaceAlpha', 0.3,...
    'AmbientStrength', 0.3,...
    'DiffuseStrength', 0.6,...
    'SpecularStrength', specularStrength,...
    'SpecularExponent', specularExponent,...
    'SpecularColorReflectance', 0.8);

hold on

% 添加边缘倒角（增强立体感）
[~,h] = contour3(X_new, Y_new, Z_new, 5);
set(h, 'LineWidth',1.5, 'EdgeColor',[0.9 0.9 1], 'LineStyle','-')

% 绘制法线指示
arrowLength = R*1.5;
quiver3(position(1), position(2), position(3),...
        direction(1), direction(2), direction(3),...
        arrowLength, 'Color',[0.9 0.2 0.2], 'LineWidth',2,...
        'MaxHeadSize',0.3, 'AutoScale','off');

% 场景设置
axis equal
xlabel('X'), ylabel('Y'), zlabel('Z')

lighting gouraud
material metal

end