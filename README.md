# MATLAB Plot Schematics Toolkits

一套用于绘制**光学实验光路示意图**的 MATLAB 函数集合：用参数化调用在三维空间中画出透镜、棱镜、分束器、光阑、晶体、光束等常见光学元件，快速拼出论文级的光路原理图。

> 导入自 `MATLAB_plot_schematics_toolkits_20250430.zip`。

## 快速开始

把本仓库目录加入 MATLAB 路径，直接运行示例：

- `Plot_Schematics.m` —— 完整光路示例：激光二极管 → 透镜组 → 锥透镜 → 晶体 → 分束器 → 光阑 → CCD 的整套光路
- `Test_ground.m` —— 单元件绘制演示（柱面透镜 + 三维箭头标注）

```matlab
p1 = [0 0 0];          % 元件起点
p2 = [0 0 1];          % 光轴方向
plotCylindricalLens(p1, p2, 1, 2, 2, 2, 'r', 0.8)
Quiver3(p1, p1+p2*3, 'r', 'r', 0.1, 0.4, 0.4)
axis([-5 5 -5 5 -5 5]); view(3)
light('Position',[1 1 1],'Style','infinite')
```

## 光学元件函数

| 类别 | 函数 |
| --- | --- |
| 透镜 | `plotCylindricalLens` · `plotPlanoConvexLens` · `plotPlanoConcaveLens` · `plotCouplingLens` · `draw_lens` |
| 棱镜 / 晶体 | `plotDispersivePrism` · `plotcrystal` |
| 分束器 | `plotBeamSplitterCube` · `plotBeamSplitterCube2` |
| 光阑 | `plotAnnularAperture` · `plotApertureDisk` · `plotFlatAperture` |
| 锥透镜 / 轴棱锥 | `plotaxicon` · `draw_axicon` |
| 探测器 / 调制器 | `myCCD`（使用 `dark_skim.jpg` 作纹理）· `mySLM` |
| 光束 | `amazing_light_bulb`（平行光束）· `createConeFrustum`（汇聚/发散过渡段）· `angular_propagation1D` |
| 几何基元 | `cube` · `plotCube` · `plotTexturedCube` · `createCylindricalLens` |
| 标注 | `Quiver3`（三维带箭头光线标注） |

## 文件说明

- 26 个 `.m` 函数文件，均为独立可调用的绘图函数或示例脚本
- `dark_skim.jpg` —— `myCCD.m` 引用的 CCD 表面纹理图

## 许可

原作者信息随压缩包分发时未附带，暂以原样归档。如需补充出处或许可声明，欢迎提 Issue / PR。
