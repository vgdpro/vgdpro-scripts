--舞动的五线谱 艾露梅尔
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.VgCard(c)
    -- 【自】：这个单位被放置到G时，通过【费用】[灵魂爆发1]，你的指令区中的你的卡每有1张，这次战斗中，这个单位的盾护+5000。
    vgd.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_MOVE,cm.op,vgf.SoulBlast(1),cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    return c:IsLocation(LOCATION_G_CIRCLE)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    local ct = Duel.GetMatchingGroupCount(nil,tp,LOCATION_ORDER,0,c)
    local defup = 5000*ct
    vgf.DefUp(c,c,defup)
end