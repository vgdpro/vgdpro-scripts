--天剑的骑士 福特
local cm,m,o=GetID()
function cm.initial_effect(c)
    VgF.VgCard(c)
    --【自】：这个单位被「天枪的骑士 勒克斯」RIDE时，通过【费用】[将手牌中的2张等级3的卡公开]，将你的牌堆顶的1张卡公开，那张卡是单位卡的话，CALL到R上，不是的话，放置到弃牌区。
    vgd.BeRidedByCard(c,m,10103002,cost,cm.operation)
    --cost公开2张三级未写
    --【起】【R】【1回合1次】：通过【费用】[计数爆发1]，选择你的1张等级3的先导者，这个回合中，力量+5000。
    vgd.EeffectTypeIgnition(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,cm.operation2,vgf.DamageCost(1),vgf.RMonsterCondition,nil,1)
end
function cm.operation(c)
    
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
    local g=Duel.SelectMatchingCard(tp,vgf.VmonsterFilter,tp,LOCATION_MZONE,0,1,1,nil)
    --条件未写出选择等级三,只写了选择V
    if g then
    VgF.AtkUp(c,g,5000,nil)
end
--一效果的operation未写（不知道该如何写展示手牌与判断单位，牌组顶公开call或者放置到弃牌区）
--二效果的条件中未写选择等级三
