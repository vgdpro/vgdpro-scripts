--努力的证明 维莉丝塔
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgf.VgCard(c)
    -- 【自】：这个单位被RIDE时，通过【费用】[将手牌中的1张卡放置到灵魂里]，从你的牌堆里探寻至多1张宝石卡，公开后加入手牌，然后牌堆洗切。
    vgd.BeRidedByCard(c,m,nil,cm.op1,cm.cost1)
    -- 【自】【R】：你施放指令卡时，通过【费用】[灵魂爆发1]，这个回合中，这个单位的力量+5000。
    vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_CHAINING,VgF.AtkUp(c,c,5000),VgF.OverlayCost(1),cm.con)
end

function cm.op1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,0,1,nil)
    if #g>0 then
        local tc = g:GetFirst()
        Duel.Sendto(tc,tp,LOCATION_HAND,nil,REASON_EFFECT)
    end
    Duel.ShuffleDeck(tp)
end

function cm.filter(c)
    return c:IsCode(0xc040) and c:IsAbleToHand()
end

function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_HAND,nil)>=1 end
    local rc=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
    local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
        Duel.HintSelection(g)
    Duel.Overlay(rc,g)
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp and vgf.RMonsterCondition(e)
end
