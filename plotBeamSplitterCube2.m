function plotBeamSplitterCube2(position, direction, edgeLength, color, faceAlpha)
% 参数校验
validateattributes(position, {'numeric'}, {'size',[1 3]});
validateattributes(direction, {'numeric'}, {'size',[1 3]});
direction = direction/norm(direction);
validateattributes(edgeLength, {'numeric'}, {'positive'});
validateattributes(color, {'numeric'}, {'size',[1 3], '>=',0, '<=',1});
validateattributes(faceAlpha, {'numeric'}, {'scalar', '>=',0, '<=',1});

% 生成基础立方体顶点
s = edgeLength/2;
vertices = [-s -s -s;  s -s -s;  s  s -s; -s  s -s;
            -s -s  s;  s -s  s;  s  s  s; -s  s  s];

% 计算旋转矩阵
zAxis = [0 0 1];
if norm(direction - zAxis) < 1e-6
    R = eye(3);
else
    rotAxis = cross(zAxis, direction);
    rotAngle = acos(dot(zAxis, direction));
    K = [0 -rotAxis(3) rotAxis(2); 
         rotAxis(3) 0 -rotAxis(1); 
         -rotAxis(2) rotAxis(1) 0];
    R = eye(3) + sin(rotAngle)*K + (1-cos(rotAngle))*(K^2);
end

% 应用坐标变换
vertices = (R * vertices')' + position;

% 定义立方体面
faces = [1 2 3 4; 5 6 7 8; 1 2 6 5; 3 4 8 7; 1 5 8 4; 2 6 7 3];

% 创建分束面顶点（空间对角线连接）
splitFaces = [
    1 3 7 5;  % 主对角线面1
    2 4 8 6;  % 主对角线面2
    1 6 7 4;  % 副对角线面1
    2 5 8 3]; % 副对角线面2

% 绘制立方体
figure
hold on

% 先绘制透明外表面
for i = 1:size(faces,1)
    patch('Vertices', vertices,...
          'Faces', faces(i,:),...
          'FaceColor', color,...
          'EdgeColor', 'none',...
          'FaceAlpha', faceAlpha,...
          'AmbientStrength', 0.3);
end

% 绘制高亮分束面（带边缘）
for i = 1:size(splitFaces,1)
    patch('Vertices', vertices,...
          'Faces', splitFaces(i,:),...
          'FaceColor', [1 0.5 0.2],... % 橙色
          'EdgeColor', [1 1 0],...      % 黄色边线
          'FaceAlpha', 0.8,...
          'LineWidth', 1.5,...
          'SpecularStrength', 1);
end

% 设置场景
axis equal
xlabel('X'), ylabel('Y'), zlabel('Z')
light('Position', position + edgeLength*[1 1 1], 'Style','local')
lighting gouraud
material([0.3 0.6 0.9 10 0.5])
view(135,30)
title(sprintf('分束立方体\n边长: %.1f  位置: [%.1f,%.1f,%.1f]',...
    edgeLength, position(1), position(2), position(3)))
grid on
rotate3d on
end