# vgdpro的卡片脚本编写文档

> 本游戏的脚本基于lua。使用自定义库: [VgD.lua](VgD.Lua), [VgDefinition.Lua](VgDefinition.Lua), [VgFuncLib.lua](VgFuncLib.Lua) 来涵括大部分需要的内容。
大家写脚本基本只需要一些基础的逻辑整理和调用对应的库就能完成编写。以下是一些最基础的教程
如果还有不懂可以加群：721095458

<details>
  <summary>目录（单击展开）</summary>
  
1. [默认脚本](#默认白板卡片脚本即默认脚本)
3. [关于vgd的效果分类](#关于vgd的效果分类)
4. [删除 PonderTag 内的的关联物品](#其三-去芜存菁)
5. [删除已有的 PonderTag](#其四-一扫而空)
6. [机械动力自带的 PonderTag](#其五-承上启下)
</details>


## 默认白板卡片脚本（即默认脚本）

```lua
    local cm,m,o=GetID()
    
    function cm.initial_effect(c)--这个函数下面用于注册效果
         vgf.VgCard(c)
         --在这之后插入自定义函数或者代码块
         cm.sample(x)
    end
    
    --可以在这之后自定义函数来调用（函数必须是cm.函数名）
    function cm.sample(x)
    	    --代码
    end
```
## 关于vgd的效果分类
vg常见的效果类型
-  **【起】启动效果**
    -  这就是最基本的手动开启的效果（类似游戏王里的茉莉②效果那样的主动效果）
-  **【自】诱发效果**
    -  有费用的自能力为诱发选发效果而无费用的为诱发必发效果（类似游戏王里xxx的效果）
-  **【永】永续效果**
    -  类似于游戏王里肿头龙的持续类效果
-  **以及指令能力**
    - 等价于游戏王中的魔法卡的发动 
