function plotPlanoConvexLens(position, direction, thickness, radius, curvatureRadius,color,alpha,txt)
    % 参数说明：
    % position: 镜片中心位置，例如 [x, y, z]
    % direction: 镜片方向（光轴方向），例如 [dx, dy, dz]
    % thickness: 镜片中心厚度
    % radius: 镜片半径
    % curvatureRadius: 凸面曲率半径（应为正数）
    % 规范方向向量
    dirVec = direction(:)/norm(direction);
    % 计算旋转矩阵
    zAxis = [0; 0; 1];
    if norm(dirVec - zAxis) < 1e-6
        R = eye(3);
    else
        % 计算旋转轴和角度
        rotAxis = cross(zAxis, dirVec);
        rotAngle = acos(dot(zAxis, dirVec));
        
        % 使用罗德里格斯公式计算旋转矩阵
        K = [0, -rotAxis(3), rotAxis(2);
             rotAxis(3), 0, -rotAxis(1);
             -rotAxis(2), rotAxis(1), 0];
        R = eye(3) + sin(rotAngle)*K + (1-cos(rotAngle))*K^2;
    end

    % 生成平面网格
    [X_plane, Y_plane, Z_plane] = createDisk(radius);
    
    % 生成凹面网格
    [X_concave, Y_concave, Z_concave] = createConcaveSurface(radius, thickness, curvatureRadius);
    
    % 生成侧面网格
    [X_side, Y_side, Z_side] = createSideSurface(radius, thickness, curvatureRadius);

    % 应用坐标变换
    [Xp, Yp, Zp] = transformCoordinates(X_plane, Y_plane, Z_plane, R, position);
    [Xc, Yc, Zc] = transformCoordinates(X_concave, Y_concave, Z_concave, R, position);
    [Xs, Ys, Zs] = transformCoordinates(X_side, Y_side, Z_side, R, position);

    % 绘制图形
    hold on
    surf(Xp, Yp, Zp, 'FaceColor',color, 'EdgeColor', 'none','FaceAlpha',alpha)
    surf(Xc, Yc, Zc, 'FaceColor', color, 'EdgeColor', 'none','FaceAlpha',alpha)
    surf(Xs, Ys, Zs, 'FaceColor', color, 'EdgeColor', 'none','FaceAlpha',alpha)
    
    text(max(Xp(:)),max(Yp(:)),max(Zp(:)),txt,'Fontname','times new roman','fontsize',20)
    axis equal
    view(3)
end

function [X, Y, Z] = createDisk(radius)
    theta = linspace(0, 2*pi, 50);
    r = linspace(0, radius, 20);
    [Theta, R] = meshgrid(theta, r);
    X = R .* cos(Theta);
    Y = R .* sin(Theta);
    Z = zeros(size(X));
end

function [X, Y, Z] = createConcaveSurface(radius, t, R_curv)
    theta = linspace(0, 2*pi, 50);
    r = linspace(0, radius, 20);
    [Theta, R] = meshgrid(theta, r);
    X = R .* cos(Theta);
    Y = R .* sin(Theta);
    Z = (-t + R_curv) - sqrt(R_curv^2 - X.^2 - Y.^2);
    Z(imag(Z) ~= 0) = NaN; % 处理无效点
end

function [X, Y, Z] = createSideSurface(radius, t, R_curv)
    theta = linspace(0, 2*pi, 50);
    h = linspace(0, 1, 20)';
    X_edge = radius * cos(theta);
    Y_edge = radius * sin(theta);
    Z_top = (-t + R_curv) - sqrt(R_curv^2 - X_edge.^2 - Y_edge.^2);
    
    X = zeros(length(h), length(theta));
    Y = zeros(length(h), length(theta));
    Z = zeros(length(h), length(theta));
    
    for i = 1:length(theta)
        X(:,i) = linspace(X_edge(i), X_edge(i), length(h));
        Y(:,i) = linspace(Y_edge(i), Y_edge(i), length(h));
        Z(:,i) = linspace(0, Z_top(i), length(h));
    end
end

function [X_new, Y_new, Z_new] = transformCoordinates(X, Y, Z, R, position)
    coords = [X(:), Y(:), Z(:)]';
    rotated = R * coords;
    translated = rotated' + position;
    X_new = reshape(translated(:,1), size(X));
    Y_new = reshape(translated(:,2), size(Y));
    Z_new = reshape(translated(:,3), size(Z));
end