--努力的证明 维莉丝塔
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.VgCard(c)
    -- 【自】：这个单位被RIDE时，通过【费用】[将手牌中的1张卡放置到灵魂里]，从你的牌堆里探寻至多1张宝石卡，公开后加入手牌，然后牌堆洗切。
    vgd.BeRidedByCard(c,m,nil,vgf.CardsFromTo(REASON_EFFECT,LOCATION_HAND,LOCATION_DECK,cm.filter,1,0),cm.cost1)
    -- 【自】【R】：你施放指令卡时，通过【费用】[灵魂爆发1]，这个回合中，这个单位的力量+5000。
    vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_CHAINING,cm.op,VgF.OverlayCost(1),cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
        VgF.AtkUp(c,c,5000)
    end
end
function cm.filter(c)
    return c:IsCode(0xc040) and c:IsAbleToHand()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return vgf.GetMatchingGroupCount(nil,tp,LOCATION_HAND,0,nil)>0 end
    local rc=vgf.GetVMonster(tp)
    local g=vgf.SelectMatchingCard(HINTMSG_XMATERIAL,tp,nil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    vgf.Sendto(LOCATION_OVERLAY,g,rc)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp and vgf.RMonsterCondition(e)
end
