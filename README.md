# vgdpro-scripts写卡说明
  调用库：
    VgD.Lua（完整效果的装封，适用于正常进行vg游戏对局的基础效果库）
    VgFuncLib.lua（散装效果的装封，因vg的效果、费用具有高重复度，适用于vg卡片效果的快捷调用）
    VgDefinition.Lua（适用于与内核对接）
  函数写在哪？
  [[
    local cm,m,o=GetID()
    function cm.initial_effect(c)
    	vgf.VgCard(c)
      xxx.function(x)
    end
    ]]
    cm.initial_effect函数下用于写入效果注册
    可以在所需位置填写匿名函数
    或在此函数后写所需函数
  调用函数库
    写在前面
      vg的效果类型
        【起】启动效果
        【自】诱发效果（有费用的自能力为诱发选发效果而无费用的为诱发必发效果）
        【永】永续效果
        以及指令能力（等价于游戏王中的魔法卡的发动）
      vg的效果是允许空发的，所以vgdpro的脚本大多不需要为效果注册Target函数（效果的预处理对象函数）
    VgD库
      VgD.SpellActivate(c,m,执行函数,条件函数,特殊的费用标识（填写卡号否则为0，适用于存在对于一下参数均适用的费用）,将手牌中的x张卡舍弃,能量爆发x,灵魂爆发x,灵魂填充x,计数爆发x) *下见①
      VgD.BeRidedByCard(c,m,卡号（被指定卡RIDE的情况下填写对应卡号否则填0）,执行函数,费用函数,条件函数,效果的预处理对象函数) *下见③
      VgD.EffectTypeTrigger(c,m,发动的区域（vg的描述中会在效果类型后描述这个效果在哪些区域适用）,自身状态变化触发/场上所以卡状态变化触发 *下见②,对应的时点,执行函数,费用函数,条件函数,效果的预处理对象函数,效果的次数限制,效果的性质 *下见④)
      VgD.EffectTypeIgnition(c,m,发动的区域,执行函数,费用函数,条件函数,效果的预处理对象函数,效果的次数限制,效果的性质 *下见④)
    VgFunction库
      VgF.VgCard(c) *下见⑤
      VgF.Stringid(卡号,行数) *下见⑥
      VgF.VMonsterFilter(Card c)/VgF.VMonsterCondition(e)  VgF.RMonsterFilter(Card c)/VgF.RMonsterCondition(e) *下见⑦
      VgF.IsLevel(Card c,... *下见⑧) *下见⑨
# 注释
  ①：因为魔合成的不向下兼容而生的函数，用于通常指令的注册，对于后5个参数均填写对应数量，如果没有可以填写“nil（无）”、“false（错误）”、“0”，推荐优先填写“0”。
  ②：填写“EFFECT_TYPE_SINGLE（自身状态变化触发）”或者“EFFECT_TYPE_FIELD（场上所以卡状态变化触发）”，不需要填写诱发选发/诱发必发，库里已经写好了。
  ③：用于效果“这个单位被RIDE时，xxxx”的注册
  ④：效果的性质内容较为特殊，可能不需要填写
  ⑤：VgD库内的函数装封，每张可入卡组的卡必须注册
  ⑥：挂钩于cdb中对应卡号的卡右下角脚本提示文字第(参数二+1)行
  ⑦：前者“V”为先导者的判断，后者“R”为后防者的判断,"Condition"为适用于“这张卡在V位/R位”的condition函数（条件函数）的装封，“Filter”为直接对参数Card c进行判断的装封
  ⑧：从这个参数开始可以填写任意数量（至少1个）的参数
  ⑨：因为vg存在等级0，而实际上等级0的卡vgdpro以原本的“level 1”来储存，所以在前端库中装封此函数，用于直接判断
  
