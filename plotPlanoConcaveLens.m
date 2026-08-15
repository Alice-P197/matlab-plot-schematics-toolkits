function plotPlanoConcaveLens(position, direction, thickness, radius, curvatureRadius,color,alpha,txt)
    % 参数说明：
    % position: 镜片中心位置，例如 [x, y, z]
    % direction: 镜片方向（光轴方向），例如 [dx, dy, dz]
    % thickness: 镜片中心厚度（平面到凸面顶点距离）
    % radius:    镜片半径
    % curvatureRadius: 凹面曲率半径（应为正数）

    % 规范方向向量
    dirVec = direction(:)/norm(direction);
    
    % 计算旋转矩阵（与平凹透镜相同）
    zAxis = [0; 0; 1];
    if norm(dirVec - zAxis) < 1e-6
        R = eye(3);
    else
        rotAxis = cross(zAxis, dirVec);
        rotAngle = acos(dot(zAxis, dirVec));
        K = [0, -rotAxis(3), rotAxis(2);
             rotAxis(3), 0, -rotAxis(1);
             -rotAxis(2), rotAxis(1), 0];
        R = eye(3) + sin(rotAngle)*K + (1-cos(rotAngle))*K^2;
    end

    % 生成平面网格
    [X_plane, Y_plane, Z_plane] = createDisk(radius);
    
    % 生成凸面网格（主要修改部分）
    [X_convex, Y_convex, Z_convex] = createConvexSurface(radius, curvatureRadius, thickness);
    
    % 生成侧面网格（调整连接方式）
    [X_side, Y_side, Z_side] = createConvexSideSurface(radius, curvatureRadius, thickness);

    % 应用坐标变换
    [Xp, Yp, Zp] = transformCoordinates(X_plane, Y_plane, Z_plane, R, position);
    [Xcv, Ycv, Zcv] = transformCoordinates(X_convex, Y_convex, Z_convex, R, position);
    [Xs, Ys, Zs] = transformCoordinates(X_side, Y_side, Z_side, R, position);

    % 绘制图形
    hold on
    surf(Xp, Yp, Zp, 'FaceColor', color, 'EdgeColor', 'none','FaceAlpha',alpha);
    surf(Xcv, Ycv, Zcv, 'FaceColor', color, 'EdgeColor', 'none','FaceAlpha',alpha);
    surf(Xs, Ys, Zs, 'FaceColor', color, 'EdgeColor', 'none','FaceAlpha',alpha);
    
    axis equal;
    text(max(Xp(:)),max(Yp(:)),max(Zp(:)),txt,'Fontname','times new roman','fontsize',20)
    view(3)
end

function [X, Y, Z] = createConvexSurface(radius, R_curv, t)
    % 生成凸面（球面方程修改）
    theta = linspace(0, 2*pi, 50);
    r = linspace(0, radius, 20);
    [Theta, R] = meshgrid(theta, r);
    X = R .* cos(Theta);
    Y = R .* sin(Theta);
    Z = (R_curv - sqrt(R_curv^2 - X.^2 - Y.^2)) + t; % 凸面方程
    Z(imag(Z) ~= 0) = NaN; % 过滤无效点
end

function [X, Y, Z] = createConvexSideSurface(radius, R_curv, t)
    % 生成连接平面和凸面的侧面
    theta = linspace(0, 2*pi, 50);
    h = linspace(0, 1, 20)';
    X_edge = radius * cos(theta);
    Y_edge = radius * sin(theta);
    Z_top = (R_curv - sqrt(R_curv^2 - X_edge.^2 - Y_edge.^2)) + t;
    
    X = zeros(length(h), length(theta));
    Y = zeros(length(h), length(theta));
    Z = zeros(length(h), length(theta));
    
    for i = 1:length(theta)
        X(:,i) = linspace(X_edge(i), X_edge(i), length(h));
        Y(:,i) = linspace(Y_edge(i), Y_edge(i), length(h));
        Z(:,i) = linspace(0, Z_top(i), length(h)); % 从平面到凸面边缘
    end
end

% 保持与平凹透镜相同的辅助函数
function [X, Y, Z] = createDisk(radius)
    theta = linspace(0, 2*pi, 50);
    r = linspace(0, radius, 20);
    [Theta, R] = meshgrid(theta, r);
    X = R .* cos(Theta);
    Y = R .* sin(Theta);
    Z = zeros(size(X));
end

function [X_new, Y_new, Z_new] = transformCoordinates(X, Y, Z, R, position)
    coords = [X(:), Y(:), Z(:)]';
    rotated = R * coords;
    translated = rotated' + position;
    X_new = reshape(translated(:,1), size(X));
    Y_new = reshape(translated(:,2), size(Y));
    Z_new = reshape(translated(:,3), size(Z));
end