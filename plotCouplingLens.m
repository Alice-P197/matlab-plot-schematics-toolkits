function plotCouplingLens(position,direction,L,r1,r2,r3,p_lens1,p_lens2,color,facealpha,txt)
%% 画出双透镜耦合光束建模
direction = direction./norm(direction);
v1 = position;
v2 = v1+L(1)*direction;
v3 = v2+L(2)*direction;
plotPlanoConvexLens(v2,-direction,p_lens1(1),p_lens1(2),p_lens1(3),[0.6,0.6,0.6],0.8,txt(1))
createConeFrustum(r1,r2,L(1),v1,direction,color,facealpha);
amazing_light_bulb(v2,direction,r2,L(2),color,facealpha);
createConeFrustum(r2,r3,L(3),v3,direction,color,facealpha);
plotPlanoConvexLens(v3,direction,p_lens2(1),p_lens2(2),p_lens2(3),[0.6,0.6,0.6],0.8,txt(2))
end