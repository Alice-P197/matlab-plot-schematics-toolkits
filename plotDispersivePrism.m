function plotDispersivePrism(position, direction, baseLength, height, color, faceAlpha, theta,text_X,txt)
% 绘制可绕轴旋转的三维色散三棱镜
% 参数：
%   position    : 几何中心坐标 [x,y,z]
%   direction   : 高度方向向量 [dx,dy,dz]
%   baseLength  : 底面三角形边长
%   height      : 棱镜高度
%   color       : 表面颜色 [R,G,B]（0-1）
%   faceAlpha   : 表面透明度（0-1）
%   theta       : 绕轴旋转角度（弧度）

% ================== 参数校验 ==================
validateattributes(position, {'numeric'}, {'size',[1 3]}, mfilename, 'position');
validateattributes(direction, {'numeric'}, {'size',[1 3]}, mfilename, 'direction');
direction = direction/norm(direction);
validateattributes(baseLength, {'numeric'}, {'positive'}, mfilename, 'baseLength');
validateattributes(height, {'numeric'}, {'positive'}, mfilename, 'height');
validateattributes(faceAlpha, {'numeric'}, {'scalar', '>=',0, '<=',1}, mfilename, 'faceAlpha');
validateattributes(theta, {'numeric'}, {'scalar'}, mfilename, 'theta');

% ================== 顶点生成 ==================
h_tri = baseLength * sqrt(3)/2;      % 底面三角形高度
geom_center = [0, h_tri/3, 0];       % 局部坐标系几何中心

% 底面顶点（局部坐标系，已中心对齐）
baseVerts = [
    -baseLength/2,  -h_tri/3,    -height/2;   % 顶点1
     baseLength/2,  -h_tri/3,    -height/2;   % 顶点2
     0,             2*h_tri/3,   -height/2;   % 顶点3
];

% 顶面顶点（沿局部z轴平移height）
topVerts = baseVerts + [0 0 height];
vertices = [baseVerts; topVerts];

% ================== 旋转矩阵计算 ==================
% 计算将z轴对齐到方向的旋转矩阵
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

% ================== 面定义 ==================
faces = {
    [1 2 3],       % 底面
    [4 5 6],       % 顶面
    [1 2 5 4],     % 前侧面
    [2 3 6 5],     % 右斜面（色散面）
    [3 1 4 6]      % 左斜面
};

% ================== 可视化 ==================
hold on

% 绘制基础面
for i = 1:length(faces)
    patch('Vertices', vertices,...
          'Faces', faces{i},...
          'FaceColor', color,...
          'EdgeColor', 'none',...
          'FaceAlpha', faceAlpha,...
          'AmbientStrength', 0.3,...
          'SpecularStrength', 0.7);
end

% 绘制色散面（带彩虹渐变）
dispersionFace = [2 3 6 5];
vertexColors = jet(4); % 生成4个顶点颜色

patch('Vertices', vertices,...
      'Faces', dispersionFace,...
      'FaceVertexCData', vertexColors,...
      'FaceColor', 'interp',...
      'EdgeColor', 'none',...
      'FaceAlpha', 0.8,...
      'SpecularStrength', 1);

% ================== 场景设置 ==================
axis equal
light('Position', position + direction*height*2, 'Style','local')
lighting gouraud
material([0.3 0.6 0.9 10 0.5])
grid on;rotate3d on
text(text_X(1),text_X(2),text_X(3),txt,'Fontname','times new roman','fontsize',20)
end