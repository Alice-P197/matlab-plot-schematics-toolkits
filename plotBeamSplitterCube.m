function plotBeamSplitterCube(position, direction, edgeLength, color, faceAlpha,text_X,txt)
% 绘制带分束面的立方体模型
% 输入参数：
%   position    : 立方体中心坐标 [x,y,z]
%   direction   : 立方体朝向向量 [dx,dy,dz]
%   edgeLength  : 立方体边长
%   color       : 表面颜色 [R,G,B]（0-1）
%   faceAlpha   : 表面透明度（0-1）


% 生成基础立方体顶点（中心在原点）
s = edgeLength/2;
vertices = [-s -s -s;  s -s -s;  s  s -s; -s  s -s;
            -s -s  s;  s -s  s;  s  s  s; -s  s  s];

% 计算旋转矩阵
zAxis = [0 0 1];
if norm(direction - zAxis) < 1e-6
    R_align = eye(3);
else
    rotAxis = cross(zAxis, direction);
    rotAngle = acos(dot(zAxis, direction));
    K = [0 -rotAxis(3) rotAxis(2); 
         rotAxis(3) 0 -rotAxis(1); 
         -rotAxis(2) rotAxis(1) 0];
    R_align = eye(3) + sin(rotAngle)*K + (1-cos(rotAngle))*(K^2);
end
if norm(direction -[1,0,0]) < 1e-6
theta = pi*2;
else
 theta = pi/2;   
end
% 计算绕方向轴旋转theta的矩阵
k = direction(:);
ct = cos(theta);
st = sin(theta);
K_mat = [0    -k(3)   k(2);
         k(3)  0     -k(1);
        -k(2)  k(1)   0];
R_rotate = ct*eye(3) + (1-ct)*(k*k') + st*K_mat;

% 组合旋转矩阵
R_total = R_rotate * R_align;

% ================== 坐标变换 ==================
vertices = (R_total * vertices')' + position;


% 定义立方体面
faces = [1 2 3 4; 5 6 7 8; 1 2 6 5; 3 4 8 7; 1 5 8 4; 2 6 7 3;1,2,7,8];

% 创建分束面顶点（内部对角面）
splitVertices = [
    mean(vertices([1 7],:));  % 1-7对角线中点
    mean(vertices([2 8],:));  % 2-8对角线中点
    mean(vertices([3 5],:));  % 3-5对角线中点
    mean(vertices([4 6],:))]; % 4-6对角线中点

% 绘制立方体
hold on

% 绘制普通面
for i = 1:size(faces,1)
    patch('Vertices', vertices,...
          'Faces', faces(i,:),...
          'FaceColor', color,...
          'EdgeColor', 'none',...
          'FaceAlpha', faceAlpha,...
          'AmbientStrength', 0.3,...
          'SpecularStrength', 0.5);
end

% 绘制分束面（金色高亮）
patch('Vertices', splitVertices,...
      'Faces', [1 2 3 4],...
      'FaceColor', [0.8 0.5 0.2],... % 金色
      'EdgeColor', 'w',...
      'FaceAlpha', 0.9,...
      'SpecularStrength', 0.9);

% 添加边缘高光
edgeColor = color;
for i = 1:size(faces,1)
    v = vertices(faces(i,:),:);
    plot3(v([1:end 1],1), v([1:end 1],2), v([1:end 1],3),'Color', edgeColor, 'LineWidth', 1);
end

% 设置场景
axis equal
xlabel('X'), ylabel('Y'), zlabel('Z')
material shiny
view(135,30);
text(text_X(1),text_X(2),text_X(3),txt,'Fontname','times new roman','fontsize',20)
grid on;rotate3d on
end