function h = createCylindricalLens(baseCenter, lensCenter, rotateAngle, color, faceAlpha, angleDeg, radius)
% 创建三维柱面透镜（修正版）
% 输入参数：
%   baseCenter:  平面端面中心坐标 [x,y,z]
%   lensCenter:  曲面端面中心坐标 [x,y,z]
%   rotateAngle: 绕轴线旋转角度（度数）
%   color:       表面颜色 (RGB向量或颜色字符)
%   faceAlpha:   表面透明度 (0-1)
%   angleDeg:    覆盖角度（度数）
%   radius:      柱面半径

% 参数验证
if nargin < 7
    error('需要提供所有输入参数');
end
axisVector = lensCenter - baseCenter;
height = norm(axisVector);
if height < 1e-6
    error('平面中心和曲面中心距离过近');
end

% 转换角度为弧度
angleRad = deg2rad(angleDeg);
rotateRad = deg2rad(rotateAngle);
n = 50; % 网格分辨率

%% 生成基础几何体（局部坐标系）
% 侧面网格
theta = linspace(-angleRad/2, angleRad/2, n);
z_local = linspace(0, height, n); % 从平面端到曲面端
[Theta, Z] = meshgrid(theta, z_local);
X = radius * cos(Theta);
Y = radius * sin(Theta);

% 端面网格
r = linspace(0, radius, n);
phi = linspace(-angleRad/2, angleRad/2, n);
[R, Phi] = meshgrid(r, phi);

% 平面端面
X_base = R .* cos(Phi);
Y_base = R .* sin(Phi);
Z_base = zeros(size(X_base)); % 平面端在z=0

% 曲面端面
X_lens = R .* cos(Phi);
Y_lens = R .* sin(Phi);
Z_lens = height * ones(size(X_lens)); % 曲面端在z=height

%% 组合所有点
points = [
    X(:), Y(:), Z(:);        % 侧面点
    X_base(:), Y_base(:), Z_base(:);  % 平面端点
    X_lens(:), Y_lens(:), Z_lens(:)    % 曲面端点
];

%% 计算坐标变换
% 计算轴线方向单位向量
axisDir = axisVector / height;

% 第一步：旋转Z轴到目标方向
rotationAxis1 = cross([0;0;1], axisDir);
if norm(rotationAxis1) < 1e-6
    R1 = eye(3);
else
    rotationAngle1 = acos(dot([0;0;1], axisDir));
    R1 = axang2rotm([rotationAxis1'./norm(rotationAxis1), rotationAngle1]);
end

% 第二步：绕轴线旋转指定角度
rotationAxis2 = axisDir;
R2 = axang2rotm([rotationAxis2', rotateRad]);

% 组合旋转矩阵
R_total = R2 * R1;

% 计算平移向量（中点平移）
midPoint = (baseCenter + lensCenter)/2;

%% 应用变换
% 旋转
rotPoints = (R_total * points')';

% 平移
transPoints = rotPoints - mean(rotPoints) + midPoint;

%% 分割点云
% 侧面点
numSide = numel(X);
sidePoints = transPoints(1:numSide, :);
X_side = reshape(sidePoints(:,1), size(X));
Y_side = reshape(sidePoints(:,2), size(Y));
Z_side = reshape(sidePoints(:,3), size(Z));

% 平面端点
numBase = numel(X_base);
basePoints = transPoints(numSide+1:numSide+numBase, :);
X_base = reshape(basePoints(:,1), size(X_base));
Y_base = reshape(basePoints(:,2), size(Y_base));
Z_base = reshape(basePoints(:,3), size(Z_base));

% 曲面端点
numLens = numel(X_lens);
lensPoints = transPoints(numSide+numBase+1:end, :);
X_lens = reshape(lensPoints(:,1), size(X_lens));
Y_lens = reshape(lensPoints(:,2), size(Y_lens));
Z_lens = reshape(lensPoints(:,3), size(Z_lens));

%% 绘制曲面
holdState = ishold;
hold on;

% 绘制侧面
h_side = surf(X_side, Y_side, Z_side,...
    'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', faceAlpha);

% 绘制平面端
h_base = surf(X_base, Y_base, Z_base,...
    'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', faceAlpha);

% 绘制曲面端
h_lens = surf(X_lens, Y_lens, Z_lens,...
    'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', faceAlpha);

if ~holdState
    hold off;
end

%% 组合句柄
h = [h_side, h_base, h_lens];

%% 设置坐标系
axis equal
xlabel('X'); ylabel('Y'); zlabel('Z');
end