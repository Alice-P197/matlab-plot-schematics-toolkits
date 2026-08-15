function plotTexturedCube(I, position, normal, sizeFront, depth, varargin)
    % 功能：绘制带前表面贴图的立方体，可控制位置、法线方向和尺寸
    % 输入参数：
    %   I          : 二维图像矩阵 (m x n x 3 彩色图像或 m x n 灰度图像)
    %   position   : 前表面中心的三维坐标 [x, y, z]
    %   normal     : 前表面法线方向的三维向量 [a, b, c]
    %   sizeFront  : 前表面尺寸 [宽度, 高度]
    %   depth      : 立方体沿法线方向的深度
    % 可选参数：
    %   'ShowFaces'    : 是否显示其他面 (true/false, 默认true)
    %   'FaceColor'    : 其他面颜色 (默认 [0.5, 0.5, 0.5])
    %   'FaceAlpha'    : 其他面透明度 (默认 0.3)
    %   'EdgeColor'    : 边线颜色 (默认 'none')

    % 解析可选参数
    p = inputParser;
    addParameter(p, 'ShowFaces', true, @islogical);
    addParameter(p, 'FaceColor', [0.5, 0.5, 0.5], @(x)validateattributes(x, {'numeric'}, {'size', [1,3]}));
    addParameter(p, 'FaceAlpha', 0.3, @(x)validateattributes(x, {'numeric'}, {'scalar', '>=',0, '<=',1}));
    addParameter(p, 'EdgeColor', 'none', @ischar);
    parse(p, varargin{:});
    
    % 单位化法线向量
    normal = normal(:) / norm(normal);
    
    % ========== 生成立方体顶点和面 ==========
    % 生成正交基向量
    ref = [0; 1; 0]; % 初始参考向量
    if abs(dot(normal, ref)) > 0.9
        ref = [1; 0; 0];
    end
    u = cross(ref, normal); u = u / norm(u);
    v = cross(normal, u);   v = v / norm(v);
    
    % 局部坐标系顶点
    w = sizeFront(1); h = sizeFront(2); d = depth;
    front = [ w/2  h/2  0; w/2 -h/2  0; -w/2 -h/2  0; -w/2  h/2  0 ];
    back = front; back(:,3) = d;
    cubeVertices = ([front; back] * [u, v, normal]') + position;
    
    % 定义面（前/后/左/右/上/下）
    faces = [1,2,3,4; 5,6,7,8; 1,2,6,5; 2,3,7,6; 3,4,8,7; 4,1,5,8];
    
    % ========== 前表面贴图 ==========
    % 提取前表面顶点
    frontVerts = cubeVertices(faces(1,:),:);
    
    % 计算贴图网格参数
    [texRows, texCols, ~] = size(I);
    [U,V] = meshgrid(linspace(0,1,texCols), linspace(0,1,texRows));
    
    % 通过双线性插值计算三维坐标
    X = frontVerts(1,1)*(1-U).*(1-V) + frontVerts(2,1)*U.*(1-V) + ...
        frontVerts(3,1)*U.*V + frontVerts(4,1)*(1-U).*V;
    Y = frontVerts(1,2)*(1-U).*(1-V) + frontVerts(2,2)*U.*(1-V) + ...
        frontVerts(3,2)*U.*V + frontVerts(4,2)*(1-U).*V;
    Z = frontVerts(1,3)*(1-U).*(1-V) + frontVerts(2,3)*U.*(1-V) + ...
        frontVerts(3,3)*U.*V + frontVerts(4,3)*(1-U).*V;
    
    % ========== 绘图 ==========
hold on;
    
    % 绘制其他面（可选）
    if p.Results.ShowFaces
        patch('Vertices', cubeVertices, 'Faces', faces(2:end,:), ...
            'FaceColor', p.Results.FaceColor, ...
            'FaceAlpha', p.Results.FaceAlpha, ...
            'EdgeColor', p.Results.EdgeColor);
    end
    
    % 前表面贴图
    surf(X, Y, Z, I, 'FaceColor', 'texturemap', 'EdgeColor', 'none', ...
        'CDataMapping', 'direct');colormap("gray");
    material metal
    % 统一设置图形属性
    axis equal tight;
    view(3);
end