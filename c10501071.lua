--倾注感情 艾贝莉娜
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.VgCard(c)
    -- 【自】：这个单位被放置到G时，通过【费用】[灵魂爆发1]，选择你的1个含有「诚意真心」的单位，这次战斗中，力量+10000。
    vgd.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_MOVE,cm.op,vgf.SoulBlast(1),cm.con)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
    local g = vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,cm.filter,tp,LOCATION_CIRCLE,0,1,1,nil)
    vgf.AtkUp(c,g,10000)
end

function cm.filter(c)
    return c:IsSetCard(0xb6) 
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    return c:IsLocation(LOCATION_G_CIRCLE)
end
