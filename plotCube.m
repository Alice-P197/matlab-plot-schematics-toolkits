function plotCubeCentered(dimensions, center, direction, brightness)
% PLOTCUBECENTERED 绘制中心可定位的三维立方体
% 输入参数：
%   dimensions : 立方体尺寸 [长(x), 宽(y), 高(z)]
%   center     : 中心点坐标 [x,y,z]
%   direction  : 朝向向量 [dx,dy,dz]
%   brightness : 明度控制 [0-1]

% 参数校验
if numel(dimensions)~=3 || numel(center)~=3 || numel(direction)~=3
    error('所有输入参数必须为三维向量');
end

% 规范方向向量
dirVec = direction(:)/norm(direction);

% 计算半尺寸
l = dimensions(1)/2;  % x半长
w = dimensions(2)/2;  % y半宽
h = dimensions(3)/2;  % z半高

% 定义立方体顶点（中心在原点）
vertices = [-l, -w, -h;   % 1 后左下
            l, -w, -h;   % 2 后右下
            l,  w, -h;   % 3 后右上
           -l,  w, -h;   % 4 后左上
           -l, -w,  h;   % 5 前左下
            l, -w,  h;   % 6 前右下
            l,  w,  h;   % 7 前右上
           -l,  w,  h];  % 8 前左上

% 面定义
faces = [1 2 3 4;   % 后表面
         5 6 7 8;   % 前表面
         1 2 6 5;   % 下表面
         3 4 8 7;   % 上表面
         1 5 8 4;   % 左表面
         2 6 7 3];  % 右表面

% 计算旋转矩阵
zAxis = [0;0;1];  % 原始朝向(z轴方向)
if norm(dirVec - zAxis) < 1e-6
    R = eye(3);
else
    rotAxis = cross(zAxis, dirVec);
    rotAngle = acos(dot(zAxis, dirVec));
    K = [0, -rotAxis(3), rotAxis(2);
         rotAxis(3), 0, -rotAxis(1);
         -rotAxis(2), rotAxis(1), 0];
    R = eye(3) + sin(rotAngle)*K + (1-cos(rotAngle))*(K^2);
end

% 执行坐标变换
rotatedVertices = (R * vertices')';     % 旋转顶点
transformedVertices = rotatedVertices + center;  % 平移到指定中心

% 颜色设置
baseColor = [0.6 0.8 1.0];  % 基础颜色(浅蓝色)
adjustedColor = baseColor * brightness;

% 创建图形

hold on
specularStrength = 0.2;        % 镜面反射强度
specularExponent = 15;         % 高光指数
% 绘制各表面
for i = 1:size(faces,1)
    patch('Vertices', transformedVertices,...
          'Faces', faces(i,:),...
          'FaceColor', adjustedColor,...
          'EdgeColor', 'k',...
          'FaceAlpha', 0.9,...
          'EdgeAlpha', 0.5,...
          'AmbientStrength', 0.3,...
          'DiffuseStrength', 0.7,...
          'SpecularStrength', 0.4,'specularExponent',15);
end

% 设置场景
axis equal
view(3);grid on
material metal
end