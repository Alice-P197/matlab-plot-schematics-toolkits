function h = plotCylindricalLens(position, direction, length, width, thickness, f, color, alpha)
    % 参数说明：
    % position:  平面中心坐标 [x,y,z]
    % direction: 柱面轴线方向向量 [dx,dy,dz]
    % length:    柱面轴线方向长度
    % width:     柱面宽度（直径）
    % thickness: 中心厚度
    % f:         焦距
    % color:     表面颜色
    % alpha:     透明度

    %% 光学参数验证
    n = 1.5;                            % 折射率
    R = f*(n-1);                        % 计算曲率半径
    assert(abs(width-2*R)<1e-6, ...      % 宽度必须等于直径
        'Width must equal 2R=%.2f', 2*R)

    %% 生成基础曲面（局部坐标系）
    % 平面参数化 (XY平面)
    [X_plane, Y_plane] = meshgrid(linspace(-length/2, length/2, 50),...
                                 linspace(-R, R, 50));
    Z_plane = zeros(size(X_plane)) + thickness/2;

    % 柱面参数化 (X轴为柱面轴线)
    theta = linspace(-pi/2, pi/2, 50);   % 半圆角度范围
    [X_cyl, Theta] = meshgrid(linspace(-length/2, length/2, 50), theta);
    Y_cyl = R*sin(Theta);                % Y方向半圆
    Z_cyl = R*cos(Theta) - R + thickness/2; % Z方向曲率

    %% 生成半圆形端面
    % 左端面 (X=-L/2)
    theta_end = linspace(-pi/2, pi/2, 50);
    Y_end = R*sin(theta_end);
    Z_end = R*cos(theta_end) - R + thickness/2;
    X_end_left = -length/2 * ones(50,50);

    % 右端面 (X=+L/2)
    X_end_right = length/2 * ones(size(theta_end));

    %% 坐标变换矩阵
    R_mat = getRotationMatrix(direction); % 获取旋转矩阵
    center = position(:);                % 平移中心

    %% 执行坐标变换
    % 平面变换
    [Xp, Yp, Zp] = transformSurface(X_plane, Y_plane, Z_plane, R_mat, center);
    
    % 柱面变换
    [Xc, Yc, Zc] = transformSurface(X_cyl, Y_cyl, Z_cyl, R_mat, center);
    
    % 左端面变换
    [Xel, Yel, Zel] = transformSurface(X_end_left, Y_end, Z_end, R_mat, center);
    
    % 右端面变换
    [Xer, Yer, Zer] = transformSurface(X_end_right, Y_end, Z_end, R_mat, center);

    %% 可视化
    hold on;
    h1 = surf(Xp, Yp, Zp, 'FaceColor',color, 'EdgeColor','none', 'FaceAlpha',alpha);
    h2 = surf(Xc, Yc, Zc, 'FaceColor',color, 'EdgeColor','none', 'FaceAlpha',alpha);
    h3 = surf(Xel, Yel, Zel, 'FaceColor',color, 'EdgeColor','none', 'FaceAlpha',alpha);
    h4 = surf(Xer, Yer, Zer, 'FaceColor',color, 'EdgeColor','none', 'FaceAlpha',alpha);
    hold off;
    
    h = [h1; h2; h3; h4];
    
    %% 光照设置
    material dull
    camlight headlight
    lighting gouraud
    axis equal
end

%% 子函数：坐标系变换
function [Xg, Yg, Zg] = transformSurface(X, Y, Z, R, center)
    [m,n] = size(X);
    pts = [X(:), Y(:), Z(:)] * R';       % 旋转
    pts = pts + center';                 % 平移
    Xg = reshape(pts(:,1), m, n);
    Yg = reshape(pts(:,2), m, n);
    Zg = reshape(pts(:,3), m, n);
end

%% 子函数：生成旋转矩阵
function R = getRotationMatrix(direction)
    z_axis = direction(:)/norm(direction);
    
    % 构造正交坐标系
    if abs(z_axis(1))<1e-6 && abs(z_axis(2))<1e-6
        x_axis = [1;0;0];
    else
        x_axis = [1;0;0] - z_axis(1)*z_axis;
        x_axis = x_axis/norm(x_axis);
    end
    y_axis = cross(z_axis, x_axis);
    R = [x_axis, y_axis, z_axis];
end