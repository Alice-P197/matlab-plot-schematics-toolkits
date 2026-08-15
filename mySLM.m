function mySLM(position, direction, sizeFront, depth,facealpha,text_X,txt)
I = imread("C:\Users\33625\Desktop\工作\相位信息图\GRIN_axicon_vortex.bmp");
plotTexturedCube(I,position,direction, sizeFront, depth,'FaceColor',[0.8,0.8,0.8],'FaceAlpha',facealpha);
text(text_X(1),text_X(2),text_X(3),txt,'Fontname','times new roman','fontsize',20)
end