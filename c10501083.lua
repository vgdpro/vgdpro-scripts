--仓促短跑 瑟尔玛
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.VgCard(c)
    -- 【自】【R】：这个单位支援先导者时，抽1张卡，选择你的手牌中的1张卡，舍弃。
    vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_SUPPORT,cm.op,nil,cm.con)
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local ca = Duel.GetAttacker()
    return vgf.VMonsterFilter(ca) and eg:GetFirst()==e:GetHandler()
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Draw(tp,1,REASON_EFFECT)
    vgf.op.CardsFromTo(REASON_EFFECT,LOCATION_DROP,LOCATION_HAND,nil,1,1)(e,tp,eg,ep,ev,re,r,rp)
end