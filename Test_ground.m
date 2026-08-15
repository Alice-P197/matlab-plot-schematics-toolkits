clc;clear;close all
p1 =[0 0 0];
for i = 1:3
    if i == 1
p2 =  [0 0 1];
    elseif i == 2
p2 =  [1 0 0];
    else
p2 =  [0 1 0];

    end
    subplot(1,3,i)
%plotDispersivePrism(p1, p2,4, 2, [0.9 0.8 0.9], 0.4,pi/5);
T = p1+p2*3;
plotCylindricalLens(p1,p2,1,2,2,2,'r',0.8)
%plotFlatAperture(1,0.4,p1,p2,'k',[0 0 0],'A')
%plotPlanoConvexLens(p1,p2,0.5,1,2,[0.3,0.2,0.2],0.4,'L1')
%plotDispersivePrism(p1, p2, 3, 3, 'r', 0.4, pi/3,[0,0,0],'Prism')
%plotBeamSplitterCube(p1, p2, 3, [0.8 0.8 0.2], 0.6,[1,1,1],'Beam Splitter');
Quiver3(p1,T,'r','r',0.1,0.4,0.4)
axis([-5,5,-5,5,-5,5])
text(T(1),T(2),T(3),['T=[',num2str(p2(1)),',',num2str(p2(2)),',',num2str(p2(3)),']'],'fontname','times new roman','fontsize',20)
light('Position', [1 1 1], 'Style', 'infinite')
lighting gouraud; material shiny
box on;grid on; ax = gca; ax.BoxStyle = 'full';
view(3)
end

