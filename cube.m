function cube(position, normal, sizeFront, depth,color,facealpha)
    % 单位化法线向量
    n = normal(:) / norm(normal);
    
    % 选择参考向量以确定旋转方向
    ref = [0; 1; 0]; % 初始参考向量为y轴
    if abs(dot(n, ref)) > 0.9
        ref = [1; 0; 0]; % 如果法线接近y轴，改用x轴作为参考向量
    end
    
    % 计算正交基向量u和v
    u = cross(ref, n);
    u = u / norm(u);
    v = cross(n, u);
    v = v / norm(v);
    
    % 构造旋转矩阵
    R = [u, v, n];
    % 生成局部坐标系中的顶点
    w = sizeFront(1);
    h = sizeFront(2);
    d = depth;
    
    % 前表面顶点（z=0）
    front = [
        w/2,  h/2, 0;
        w/2, -h/2, 0;
       -w/2, -h/2, 0;
       -w/2,  h/2, 0;
    ];
    
    % 后表面顶点（z=depth）
    back = front;
    back(:,3) = d;
    
    % 合并顶点
    localVerts = [front; back];
    
    % 转换为世界坐标系
    cubeVertices = (R * localVerts')' + position;

    patch('Vertices',  cubeVertices, 'Faces', [
    1,2,3,4;    % 前表面
    5,6,7,8;    % 后表面
    1,2,6,5;    % 右侧面
    2,3,7,6;    % 下表面
    3,4,8,7;    % 左侧面
    4,1,5,8;    % 上表面
], 'FaceColor', color, 'FaceAlpha', facealpha);
axis equal;
end