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
6. [VgFuncLib函数库详解](#vgfunclib函数库详解)
   1. [每个卡的必备](#1每个卡的必备)
   2. [提示文字](#2提示文字)
   3. [先导者/后防者的判断](#3先导者后防者的判断)
   4. [等级的判断](#4等级的判断)
   5. [等级的判断 其二](#5等级的判断-其二)
      
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
	e1:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
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
 
# [VgD函数库](VgD.Lua)详解

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

## 1.指令卡的注册范例

```lua
vgd.SpellActivate(c, m, op, con, cost)
```

范例 : [骤阳之进化](c10101015.lua)

> **通过【费用】[计数爆发1]施放！**
> 
> **选择你的1个单位, 这个回合中, 力量+5000。选择你的弃牌区中的1张「瓦尔里纳」, 加入手牌。**

```lua
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.SpellActivate(c,m,cm.operation,vgf.DamageCost(1))
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	vgf.AtkUp(c,g,5000,nil)
	vgf.SearchCard(LOCATION_HAND,LOCATION_DROP,cm.filter)(e,tp,eg,ep,ev,re,r,rp)
end
function cm.filter(c)
	return c:IsCode(10101006)
end
```

## 2.特别用于“被RIDE时”的【自】能力范例

```lua
vgd.BeRidedByCard(c, m[, code, op, cost, con, tg])
```

参数注释

> **code : 被指定卡 RIDE 的情况下填写对应卡号, 否则填0**

范例 : [焰之巫女 莉诺](c10101003.lua)

> **这个单位被「焰之巫女 蕾尤」RIDE时, 从你的牌堆里探寻至多1张「托里科斯塔」, CALL到R上, 然后牌堆洗切。**

```lua
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.BeRidedByCard(c,m,10101002,vgf.SearchCard(LOCATION_MZONE,LOCATION_DECK,cm.filter))
end
function cm.filter(c)
	return c:IsCode(10101009)
end
```

## 3.【自】能力范例的注册范例

```lua
vgd.EffectTypeTrigger(c, m, loc, typ, code[, op, cost, con, tg, count, property])
```

参数注释

> **loc : 发动的区域（vg的描述中会在效果类型后描述这个效果在哪些区域适用） `填 nil 则默认为 LOCATION_MZONE`**
> 
> **typ : 自身状态变化触发/场上的卡状态变化触发 `填 nil 则填默认为 EFFECT_TYPE_SINGLE`**
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
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation,nil,cm.condition)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=vgf.AtkUp(c,c,5000,nil)
		vgf.EffectReset(c,e1,EVENT_BATTLED)
	end
	if vgf.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil,nil):GetFirst():GetOverlayCount()>=2 and Duel.SelectEffectYesNo(tp,vgf.stringid(VgID,10)) then
		local cg=vgf.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst():GetOverlayGroup():Select(tp,2,2,nil)
        if vgf.Sendto(LOCATION_DROP,cg,REASON_COST)==2 then
			local g=vgf.SelectMatchingCard(HINTMSG_LEAVEFIELD,e,tp,vgf.RMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
			vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
		end
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.RMonsterCondition(e) and c:GetFlagEffectLabel(FLAG_CONDITION)==201 and vgf.VMonsterFilter(Duel.GetAttackTarget())
end
```

## 4.特别用于“攻击击中时”的【自】能力范例

```lua
vgd.EffectTypeTriggerWhenHitting(c, m, loc, typ[, op, cost, con, tg, count, p, property, stringid])
```

参数注释

> **loc : 发动的区域（vg的描述中会在效果类型后描述这个效果在哪些区域适用） `填 nil 则默认为 LOCATION_MZONE`**
> 
> **typ : 自身状态变化触发/场上的卡状态变化触发 `填 nil 则填默认为 EFFECT_TYPE_SINGLE`**
> 
> **count : 效果的次数限制**
> 
> **p : 击中的卡的持有者 `填 nil 则填默认为 击中的卡的当前持有者`**
>
> **property : 效果的性质**

范例 : [瓦尔里纳·勇气](c10401001.lua)

> **【自】【R】【1回合1次】：处于【超限舞装】状态的这个单位的攻击击中时，通过【费用】[计数爆发1，将手牌中的1张卡舍弃]，将这个单位重置。**

```lua
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTriggerWhenHitting(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,cm.op,cm.cost,cm.con)
end
function cm.con(e)
	local c=e:GetHandler()
	return c:GetFlagEffectLabel(FLAG_CONDITION)==201 and vgf.RMonsterCondition(e)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ChangePosition(c,POS_FACEUP_ATTACK)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,chk) and vgf.DisCardCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	end
	vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	vgf.DisCardCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
end
```

## 5.【起】能力注册范例

```lua
VgD.EffectTypeIgnition(c, m[, loc, op, cost, con, tg, count, property])
```

参数注释

> **loc : 发动的区域（vg的描述中会在效果类型后描述这个效果在哪些区域适用） `填 nil 则默认为 LOCATION_MZONE`**
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
	vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,vgf.SearchCard(LOCATION_HAND,LOCATION_MZONE,LOCATION_DROP,cm.filter),vgf.DisCardCost(1),nil,nil,1)
end
function cm.filter(c)
	return c:IsLevel(0)
end
```

## 6.特别用于“力量上升”的【永】能力注册范例

```lua
vgd.EffectTypeContinuousChangeAttack(c,m, typ, val[, con, tg, loc_self, loc_op, reset, mc])
```

参数注释

> **typ : 自身力量上升/场上的卡力量上升 `填 nil 则填默认为 EFFECT_TYPE_SINGLE`**
> 
> **val : 力量上升的具体数值**
>
> **loc_self/loc_op : 效果的影响范围 使其他单位力量上升时需要填写**
>
> **reset/mc : 效果的拥有着/重置时间 使其他单位获得此能力时需要填写**

范例 : [极光战姬 阿嘉拉·胭脂](c10401006.lua)

> **【永】【R/G】：被收容在你的监狱的对手的卡有2张以上的话，这个单位的力量+5000、盾护+10000。**

```lua
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeContinuousChangeAttack(c,m,EFFECT_TYPE_SINGLE,5000,function(e) return vgf.RMonsterCondition(e) and cm.con(e) end)
	vgd.EffectTypeContinuousChangeDefense(c,m,EFFECT_TYPE_SINGLE,5000,cm.con)
end
function cm.con(e)
	local tp=e:GetHandlerPlayer()
	return vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_ORDER,0,2,nil)
end
function cm.filter(c)
	return c:GetFlagEffect(FLAG_IMPRISON)>0
end
```

## 7.全局检测（用于检测本回合（或者更加时间）做过什么行为）

```lua
VgD..GlobalCheckEffect(c, m, typ, code, con[, op])
```

参数注释

> **op : 给自身注册一个标记，非特殊情况函數内容不需填写**
> 
> **con : 触发注册标记的具体情况**
>
> **code : 触发注册标记的时点**

范例 : [六星彩 海璃](c10301001.lua)

> **【自】【V】：这个单位攻击的战斗结束时，这个回合中你进行了人格RIDE的话，选择你的手牌中的至多2张卡，分别CALL到前列和后列的各1个R上。**

```lua
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.GlobalCheckEffect(c,m,EVENT_SPSUMMON_SUCCESS,cm.checkcon)
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_SELFRIDE)
end
```

## 8.其他效果注册

说明：
> 前面的卡片能力注册均是基于函数库"VgD.lua"的封装函数，但vg卡片能力种类繁多，并非所有能力都能为其封装，故有以下的基于原版ygopro写法的能力注册

范例 : [天枪的骑士 勒克斯](c10103002.lua)

> **【永】【R】：你的回合中，你的等级3的单位有3个以上的话，这个单位获得『支援』的技能，力量+5000。**

```lua
local cm,m,o=GetID()
function cm.initial_effect(c)
    VgF.VgCard(c)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_ADD_SKILL)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(SKILL_SUPPORT)
    e2:SetCondition(cm.condition)
    c:RegisterEffect(e2)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return vgf.VMonsterCondition(e) and vgf.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_MZONE,0,3,nil,3)
end
```

# [VgFuncLib函数库](VgFuncLib.lua)中为书写便捷而封装的函数

## 1.初始化

对vg卡片进行初始化，使其符合vg对局规则

```lua
vgf.VgCard(c)
```

## 2.用于行为的封装函数（仅用于operation函数）：从X1处寻找卡送去X2处

```lua
vgf.SearchCard(loc_to, loc_from, f[, int_max, int_min, ...])
```
返回值：int 【具体操作的数量】

参数注释

> **loc_to : 找到的卡送去某处**
> 
> **loc_from : 从某处找卡**
> 
> **f : 过滤函数 `即：找什么样的卡`**
> 
> **int_max : 找至多几张卡 `填nil | 不填则为1张`**
> 
> **int_min : 找至少几张卡 `一般用于“探寻至多x张”的字样，此时填0，填nil | 不填则等同于int_max`**
> 
> **... : 额外参数 `如过滤函数内容为cm.filter(c,e,tp)，c为内核对函数传递的参数（即遍历到的每张卡），e,tp则需从额外参数传入`**

## 3.用于行为的封装函数：力量上升

```lua
vgf.AtkUp(c, g, val[, reset, resetcount])
```
返回值：Effect/table 【注册的效果/注册的效果组成的数组】

参数注释

> **c : 以卡片c的名义 `一般是拥有此效果的卡（即e:GetHandler()）`**
> 
> **g : 力量上升的卡**
> 
> **val : 力量上升的数值,可以填写部分字符串型变量比如"DOUBLE"**
> 
> **reset : 力量上升重置时点 `因为客户端底层缺陷，部分重置时点需其他函数辅助，详情见下文4`**
> 
> **resetcount : 每经过一次reset时点，resetcount数值减少1，为0便重置 `填nil | 不填则为1`**

与vgf.AtkUp相似函数的函数

```lua
vgf.DefUp(c,g,val,reset,resetcount)--上升护盾
vgf.StarUp(c,g,val,reset,resetcount)--上升暴击值
```

## 4.用于行为（operation函数）的封装函数：效果重置

```lua
vgf.EffectReset(c,e,code,con)
```

返回值：void 【无】

参数注释

> **c : 以卡片c的名义 `一般是拥有此效果的卡（即e:GetHandler()）`**
> 
> **e : 需要重置的效果 `也可以是多个Effect类型变量组成的table`**
> 
> **code : 重置时点**
> 
> **con : 重置的前提条件**

## 5.用于行为的封装函数：选择卡片

```lua
vgf.SelectMatchingCard(hintmsg,e,select_tp,f,tp,loc_self,loc_op,int_min,int_max,except_g,...)
```

返回值：Group 【选择的卡片组】

参数注释

> **hintmsg : 游戏中显示框的提示内容**
> 
> **e : 效果本身 `operation函数的第一个参数e`**
> 
> **select_tp : 做选择的玩家**
> 
> **f : 过滤函数 `即：选择什么样的卡`**
> 
> **tp | loc_self | loc_op : 以tp的视角来看，tp的loc_self区域和，tp对手的loc_op区域**
> 
> **int_min | int_max : 选最少int_min张最多int_max张卡**
> 
> **except_g : 选择except_g以外的卡**
> 
> **... : 额外参数 `如过滤函数内容为cm.filter(c,e,tp)，c为内核对函数传递的参数（即遍历到的每张卡），e,tp则需从额外参数传入`**

此函数一般与local配合使用，即将选择出的group定义为一个变量，便于后续进行处理 

如：
```lua
local g=vgf.SelectMatchingCard(hintmsg,e,tp,f,tp,loc_self,loc_op,int_min,int_max,except_g)
```

与vgf.SelectMatchingCard相似函数的函数

```lua
vgf.IsExistingMatchingCard(f,tp,loc_self,loc_op,int,except_g,...)--判断是否存在至少int张符合的卡
vgf.GetMatchingGroup(f,tp,loc_self,loc_op,except_g,...)--得到所有符合的卡
vgf.GetMatchingGroupCount(f,tp,loc_self,loc_op,except_g,...)--得到所有符合的卡的数量
```

## 6.用于行为的封装函数：将卡送去某处

```lua
vgf..Sendto(loc,sg,...)
```

返回值：int 【具体操作的数量】

参数注释

> **loc : 送去的区域**
> 
> **sg : 操作的卡片**
> 
> **... : 额外参数，根据loc的不同而不同**
> 
> **LOCATION_DROP : reason**
> 
> **LOCATION_DECK : tp,seq,reason `seq可选SEQ_DECKTOP/SEQ_DECKBOTTOM/SEQ_DECKSHUFFLE`**
> 
> **LOCATION_HAND : p | nil,reason `p为送去的玩家，送去原本持有者则填nil`**
> 
> **LOCATION_REMOVED : pos,reason**
> 
> **LOCATION_EXILE : reason**
> 
> **LOCATION_OVERLAY : c `c为叠放的卡，填nil | 不填则为先导者`**
> 
> **LOCATION_TRIGGER : tp,tp,LOCATION_FZONE,POS_FACEUP,true**
> 
> **LOCATION_MZONE : sumtype,tp,zone,pos,chk `chk为0则Call到不存在单位的圆阵`**
> 
> **其他区域 : c,tp,pos,reason**