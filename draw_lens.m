function draw_lens(p,a1,a2,s1,s2)
[X,Y,Z] = sphere(20);
hold on
surf(a2*X+p(1),a1*Y+p(2),a1*Z+p(3),'EdgeColor','none','FaceColor',s1,'FaceAlpha',s2); freezeColors
end