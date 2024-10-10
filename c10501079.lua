--美丽的假日 菲尔缇萝萨
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgf.VgCard(c)
    -- 【自】：这个单位被RIDE时，通过【费用】[灵魂爆发1]，选择你的弃牌区中的至多1张〈幽灵〉，加入手牌。
    vgd.BeRidedByCard(c,m,nil,cm.op,OverlayCost(1))
    -- 【永】【V/R】：你的回合中，你的R上有〈幽灵〉的话，这个单位的力量+2000。
    vgd.EffectTypeContinuousChangeAttack(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,2000,cm.con)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
    VgF.SearchCard(LOCATION_HAND,LOCATION_GRAVE,cm.filter,1,0)(e,tp,eg,ep,ev,re,r,rp)
end

function cm.con(e)
    local tp=e:GetHandlerPlayer()
    return vgf.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE,0,1,nil) and Duel.GetTurnPlayer()==tp
end

function cm.filter(c)
    return c:IsSetCard(0xa013) 
end

function cm.filter1(c)
    return c:IsSetCard(0xa013) and vgf.RMonsterFilter(c)
end