# vgdpro的卡片脚本编写文档

> 本游戏的脚本基于lua。使用自定义库: [VgD](VgD.Lua), [VgDefinition](VgDefinition.Lua), [VgFuncLib](VgFuncLib.Lua) 来涵括大部分需要的内容。

大家写脚本基本只需要一些基础的逻辑整理和调用对应的库就能完成编写。以下是一些最基础的教程

如果还有不懂可以加群：721095458

<details>
  <summary>目录（单击展开）</summary>
  
1. [默认脚本](#默认白板卡片脚本即默认脚本)
2. [关于vgd的效果分类](#关于vgd的效果分类)
3. [效果注册范例](#效果注册范例)
4. [基础常量介绍](#typecodeproperty都具体有啥)
5. [VgD函数库详解](#vgd函数库详解)
   1. [指令卡cost](#1指令卡cost)
   2. [被RIDE时](#2被ride时)
   3. [触发类效果](#3触发类效果)
   4. [启动类效果](#4启动类效果)
      
</details>


# 默认白板卡片脚本（即默认脚本）

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

# 关于vgd的效果分类
vg常见的效果类型
-  **【起】启动效果**
    -  这就是最基本的手动开启的效果（类似游戏王里的茉莉②效果那样的主动效果）
-  **【自】诱发效果**
    -  有费用的自能力为诱发选发效果而无费用的为诱发必发效果（类似游戏王里xxx的效果）
-  **【永】永续效果**
    -  类似于游戏王里肿头龙的持续类效果
-  **以及指令能力**
    - 等价于游戏王中的魔法卡的发动 


> **vg的效果是允许空发的，所以vgdpro的脚本大多不需要为效果注册Target函数（后面会提到）**

# 效果注册范例
那既然现在知道了有哪些种类的效果，就可以开始介绍如何给卡片增加对应的效果了

比如我们这里要给某一张卡写一个效果
> **【自】：这个单位被RIDE时，你是后攻的话，抽1张卡。**


```lua
--默认内容
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	--在这之后加入需要注册的效果
	local e1=Effect.CreateEffect(c)--创建一个效果
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)--效果的类型
	e1:SetCode(EVENT_BE_MATERIAL)--什么情况下会发动这个效果
	e1:SetProperty(EFFECT_FLAG_EVENT_PLAYER)--我也不懂这是干啥的
	e1:SetCondition(cm.condition)--效果的条件
	e1:SetOperation(cm.operation)--效果的内容
	c:RegisterEffect(e1)--把这个效果绑定到这张卡
end
--效果的条件
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==1 and Duel.GetTurnPlayer()==tp
end
--效果的内容
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
```

但是就如我们之前所说。我们使用自定义库涵括了大部分需要的内容, 所以这个效果也可以直接简写成这样:


```lua
--默认内容
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.BeRidedByCard(c,m,nil,cm.operation,nil,cm.condition) --只要这一句就完成了上面7行的内容
end
--效果的条件
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	  return tp==1 and Duel.GetTurnPlayer()==tp
end
--效果的内容
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	  Duel.Draw(tp,1,REASON_EFFECT)
end
```

而函数里传入的e,tp,eg,ep,ev,re,r,rp分别是
- `e`:
- `tp`:当前回合玩家的编号()

# type、code、property都具体有啥

 那我怎么知道这些常量的具体意义呢？可以直接在编辑器里鼠标悬停在这些常量上查看所有常量
 ![image](https://i.postimg.cc/GmFVmkpB/Clip-2024-04-09-11-11-23.png)
 
# VgD函数库详解

> **函数的参数若位于 `[ ]` 则为可选参数(即可不填)**

常用参数解析

> **c : 注册这个效果的卡**
>
> **m : 这张卡的卡号**
>
> **con : 效果的条件**
> 
> **cost : 效果的费用**
>
> **tg : 效果的预处理对象函数**
>
> **op : 效果的内容**

## 1.指令卡cost

因为魔合成的不向下兼容而生的函数, 用于通常指令的注册

```lua
VgD.SpellActivate(c, m, op, con[, chk, dis, eb, sb, sc, cb])
```

参数注释

> **chk : 特殊的费用标识（填写卡号否则为0, 适用于存在以下参数不适用的费用） 不填默认为 nil**
> 
> **dis : 将手牌中的x张卡舍弃 不填默认为 0**
> 
> **eb : 能量爆发x (Energy Blast) 不填默认为 0**
> 
> **sb : 灵魂爆发x (Soul Blast) 不填默认为 0**
>
> **sc : 灵魂填充x (Soul Charge) 不填默认为 0**
> 
> **cb : 计数爆发x (Counter Blast) 不填默认为 0**

范例 : [骤阳之进化](c10101015.lua)

> **通过【费用】[计数爆发1]施放！**
> 
> **选择你的1个单位, 这个回合中, 力量+5000。选择你的弃牌区中的1张「瓦尔里纳」, 加入手牌。**

```lua
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgf.VgCard(c)
    vgd.SpellActivate(c,m,vgf.SearchCard(LOCATION_DROP,cm.filter))
end
function cm.filter(c)
    return c:IsCode(10101006)
end
```

## 2.被RIDE时

用于被RIDE时效果的注册

```lua
VgD.BeRidedByCard(c, m[, code, op, cost, con, tg])
```

参数注释

> **code : 被指定卡 RIDE 的情况下填写对应卡号, 否则填0**

范例 : [焰之巫女 莉诺](c10101003.lua)

> **这个单位被「焰之巫女 蕾尤」RIDE时, 从你的牌堆里探寻至多1张「托里科斯塔」, CALL到R上, 然后牌堆洗切。**

```lua
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.BeRidedByCard(c, m, 10101002, vgf.SearchCardSpecialSummon(LOCATION_DECK,cm.filter))
end
function cm.filter(c)
    return c:IsCode(10101009)
end
```

## 3.触发类效果

用于触发类型效果的注册

```lua
VgD.EffectTypeTrigger(c, m, loc, typ, code[, op, cost, con, tg, count, property])
```

参数注释

> **loc : 发动的区域（vg的描述中会在效果类型后描述这个效果在哪些区域适用） 填 nil 则默认为 LOCATION_MZONE **
> 
> **typ : 自身状态变化触发/场上的卡状态变化触发 填 nil 则填默认为 EFFECT_TYPE_SINGLE **
> 
> **code : 对应的时点**
>
> **count : 效果的次数限制**
>
> **property : 效果的性质**

范例 : [瓦尔里纳](c10101006.lua)

> **【自】【R】：处于【超限舞装】状态的这个单位攻击先导者时，这次战斗中，这个单位的力量+10000。接着通过【费用】[灵魂爆发2]，选择对手的1张后防者，退场。**

```lua
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	-- 处于【超限舞装】状态的这个单位攻击先导者时，这次战斗中，这个单位的力量+10000
	vgd.EffectTypeTrigger(c, m, LOCATION_MZONE, EFFECT_TYPE_SINGLE, EVENT_ATTACK_ANNOUNCE, cm.operation2, nil, cm.condition2)
	-- 接着通过【费用】[灵魂爆发2]，选择对手的1张后防者，退场。
	vgd.EffectTypeTrigger(c, m, LOCATION_MZONE, EFFECT_TYPE_FIELD, EVENT_CUSTOM+m, cm.operation3, vgf.OverlayCost(2), cm.condition3)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	VgF.AtkUp(c,c,10000,nil)
	Duel.RaiseEvent(c,EVENT_CUSTOM+m,e,0,tp,tp,0)
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.RMonsterCondition(e) and c:GetFlagEffectLabel(ConditionFlag)==201 and vgf.VMonsterFilter(Duel.GetAttackTarget())
end
function cm.condition3(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst()==e:GetHandler()
end
function cm.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LEAVEONFIELD)
	local g=Duel.SelectTarget(tp,vgf.RMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
	if g then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
```

## 4.启动类效果

用于启动类型效果的注册

```lua
VgD.EffectTypeIgnition(c, m[, loc, op, cost, con, tg, count, property])
```

参数注释

> **loc : 发动的区域（vg的描述中会在效果类型后描述这个效果在哪些区域适用） 填 nil 则默认为 LOCATION_MZONE **
> 
> **count : 效果的次数限制**
>
> **property : 效果的性质**

范例 : [天轮圣龙 涅槃](c10101001.lua)

> **【起】【V】【1回合1次】：通过【费用】[将手牌中的1张卡舍弃]，选择你的弃牌区中的1张等级0的卡，CALL到R上。**

```lua
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeIgnition(c, m, LOCATION_MZONE, vgf.SearchCardSpecialSummon(LOCATION_DROP,cm.filter), vgf.DisCardCost(1), nil, nil, 1)
end
function cm.filter(c)
	return vgf.IsLevel(c,0)
end
```
