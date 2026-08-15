function createConeFrustum(r1, r2, h, position, direction, color,alpha)
% 创建可定位的圆锥台几何模型
% 输入参数：
%   r1       - 下底面半径
%   r2       - 上底面半径
%   h        - 高度
%   direction - 方向向量（三维）
%   color     - RGB颜色，例如[1 0 0]
%   position  - 下底面中心坐标（三维，可选，默认[0 0 0]）

% 参数检查与默认值处理
if nargin < 5
    error('至少需要5个输入参数');
end
if nargin < 6 || isempty(position)
    position = [0 0 0]; % 默认位置在原点
end

% 验证位置参数
validateattributes(position, {'numeric'}, {'size', [1 3]}, mfilename, 'position');

% 归一化方向向量
v = direction(:)';
if norm(v) < eps
    error('方向向量不能为零向量。');
end
v = v / norm(v);

% 计算旋转矩阵
k = [0 0 1]; % 原始方向
if all(abs(v - k) < eps)
    R = eye(3);
else
    % 计算旋转轴和旋转角度
    rot_axis = cross(k, v);
    rot_axis = rot_axis / norm(rot_axis);
    theta = acos(dot(k, v));
    
    % 使用罗德里格斯公式计算旋转矩阵
    K = [0 -rot_axis(3) rot_axis(2);
          rot_axis(3) 0 -rot_axis(1);
         -rot_axis(2) rot_axis(1) 0];
    R = eye(3) + sin(theta)*K + (1-cos(theta))*(K*K);
end

% 生成圆锥台侧面网格
n = 50; % 圆周分段数
m = 50; % 高度层数
radius = linspace(r1, r2, m);
[x, y, z] = cylinder(radius, n);
z = z * h;
% 应用旋转
coords = [x(:), y(:), z(:)];
coords_rot = coords * R';

% 添加位置偏移
coords_rot = coords_rot + position; % 关键修改：平移操作

% 重塑网格坐标
xr = reshape(coords_rot(:,1), size(x));
yr = reshape(coords_rot(:,2), size(y));
zr = reshape(coords_rot(:,3), size(z));
% 绘制并设置材质属性
surf(xr, yr, zr, 'FaceColor', color, 'EdgeColor', 'none','FaceAlpha',alpha);

% 设置光照和材质属性
material([0.8, 0.6, 0.4, 50, 0.5]); % [镜面反射, 漫反射, 环境光, 高光指数, 光泽度]

% 设置坐标轴属性
axis equal;
xlabel('X'); ylabel('Y'); zlabel('Z');
grid on;
view(3);
end