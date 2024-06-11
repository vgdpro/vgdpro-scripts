--活力交响乐
local cm,m,o=GetID()
function cm.initial_effect(c)--这个函数下面用于注册效果
    vgf.VgCard(c)
    -- 这个回合中你的先导者被攻击击中过的话，选择1个被攻击的单位，这次战斗中，力量+30000。
    vgd.QuickSpell(c,cm.op)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
        -- 需要判断被击中过,这段未实现，辛苦群主大大了~/doge
    -- if then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
    local g = Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.HintSelection(g)
    local e1 = vgf.AtkUp(c,g,30000,nil)
    vgf.EffectReset(c,e1,EVENT_BATTLED)
end

function cm.filter(c)
    local a = Duel.GetAttackTarget()
    return c == a
end

