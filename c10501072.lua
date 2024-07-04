--魅惑的微笑 采塞利娅
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgf.VgCard(c)
    -- 【自】：这个单位从手牌登场到R时，你其他的后防者有3张以上的话，通过【费用】[计数爆发1]，抽1张卡。
    vgd.EffectTypeTrigger(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,vgf.DamageCost(1),cm.con)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    return vgf.RMonsterFilter(c) and c:IsPreviousLocation(LOCATION_HAND) and vgf.IsExistingMatchingCard(vgf.RMonsterFilter,tp,LOCATION_MZONE,0,3,c)
end
