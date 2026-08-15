clc;clear;close all;
figure('Position',[-1920 0 1920 1200],'Color','w')
p1 = 0;          % 主体光路x坐标
p2 = 15;         % 副光路x坐标
delta = 5;       % 接受平面距离BS2位置
y0 = -18;        % L0位置
y1 = -16;        % Axicon位置
y2 = -13;        % L1位置
y3 = -10;        % L2位置
y4 = -9;         % 晶体位置
y5 = -8;         % L3位置
y6 = 0;          % BS1位置
y7 = y6+(p2-p1); % L6位置
d_axicon = 0.5;
beam_diameter_major = 0.3;
beam_diameter_minor = 0.1;
beam_color = 'r';
% 绘制光束
createConeFrustum(1, beam_diameter_major, y0+20,[p1,-20,0], [0, 1, 0], beam_color,0.4);                  % LD发散到L0过渡
amazing_light_bulb([p1,y0,0],[0,1,0],beam_diameter_major,y2-y0,beam_color,0.4)                           % L0到L1光线
createConeFrustum(beam_diameter_major, beam_diameter_minor, y4-y2,[p1,y2,0], [0, 1, 0], beam_color,0.4); % L1到晶体过渡
createConeFrustum(beam_diameter_major, beam_diameter_minor, y5-y4,[p1,y5,0], [0, -1, 0], beam_color,0.4);% 晶体到L3过渡
amazing_light_bulb([p1,y5,0],[0,1,0],beam_diameter_major,y7-y5,beam_color,0.4);                          % L3到L6光线

amazing_light_bulb([p1,0,0],[1,0,0],beam_diameter_major,(p2-p1)/2,beam_color,0.4);           % BS1到光阑光线
amazing_light_bulb([p1+(p2-p1)/2,0,0],[1,0,0],beam_diameter_minor,(p2-p1)/2,beam_color,0.4); % 光阑到L5光线
amazing_light_bulb([p2,0,0],[0,1,0],beam_diameter_minor,p2-p1+delta,beam_color,0.4);         % L5到CCD光线

amazing_light_bulb([p1,y7,0],[1,0,0],beam_diameter_major,(p2-p1)/2+0.5,beam_color,0.4)                         % L6到 透镜L7光线   
createConeFrustum(beam_diameter_major, beam_diameter_minor, (p2-p1)/2-0.5,[(p2-p1)/2+0.5,y7,0], [1,0,0],beam_color,0.4); % 透镜L7光线过渡 
%amazing_light_bulb([p1+(p2-p1)/2+0.5,y7,0],[1,0,0],beam_diameter_minor,(p2-p1)/2-0.5,beam_color,0.4)           % L7到BS2光线

% 绘制镜片% 定义镜片参数
plotPlanoConvexLens([p1, y0, 0], [0,-1, 0], 0.5, 1, 3,'b',0.5,'L0');
plotaxicon([p1,y1,0],[p1,y1+d_axicon,0],1,'b',0.9,[p1,y1,1],'Axicon');
plotPlanoConvexLens([p1,y2,0], [0,1,0], 0.5, 1, 2,'b',0.5,'L1');
plotPlanoConcaveLens([p1,y3,0], [0,1,0], 0.1, 1, 10,[0.8,0.8,0.8],0.5,'L2');
plotcrystal([1 1 0.5], [p1,y4,0], [0 1 0],[0.6,0.5,0.5], 0.5,[p1,y4,1],'Nd^{3+}:YAG');
plotPlanoConcaveLens([p1,y5,0], [0,-1,0], 0.1, 1,5,[0.8,0.8,0.8],0.5,'L3');
plotPlanoConcaveLens([p2, y6, 0], [-1,1, 0],0.5, 1, 3,[0.8,0.8,0.8],0.5,'L5');
plotPlanoConcaveLens([p1, y7, 0], [1,-1, 0], 0.5, 1, 3,[0.8,0.8,0.8],0.5,'L6');
plotPlanoConvexLens([p1+(p2-p1)/2, y7, 0], [-1,0, 0], 0.5, 1, 2,[0.8,0.8,0.8],0.5,'L7');
%% 绘制分束立方体
plotBeamSplitterCube([p1 y6 0], [0 1 0], 1.5, [0.8 0.8 0.2], 0.4,[p1,y6,1],'BS1')
plotBeamSplitterCube([p2 y7 0], [0 1 0], 1.5, [0.8 0.8 0.2], 0.4,[p2,y7,1],'BS2')
%% 绘制CCD
myCCD([p2,p2-p1+delta,0],[0,-1,0.03],1,2,[p2,y7+delta,1],'CCD');
%% 绘制平面圆孔光阑
plotFlatAperture(1, 0.2, [(p2+p1)/2 y6 0], [1 0 0], 'k',[p1+(p2-p1)/2,y6,1],'Aperture')
%% 添加光照
light('Position', [-20 12 9], 'Style', 'infinite')
lighting gouraud; material shiny

box on;grid on; ax = gca; ax.BoxStyle = 'full';
view(3);