-- 享乐的才媛 菲尔缇萝萨
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	-- 【自】：这个单位被RIDE时，通过【费用】[将手牌中的1张〈幽灵〉的普通单位卡公开，放置到牌堆顶]，选择你的弃牌区中的1张〈幽灵〉，加入手牌。
	vgd.BeRidedByCard(c,m,nil,VgF.CardsFromTo(REASON_EFFECT,LOCATION_HAND,LOCATION_DROP,Card.IsSetCard,1,0,0xa013),cm.cost)
	-- 【永】【V/R】：你的回合中，你的R上的〈幽灵〉有3张以上的话，这个单位的力量+5000。
	vgd.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 5000, cm.con1)
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return vgf.IsExistingMatchingCard(cm.filter3,tp,LOCATION_HAND,0,1,nil) end
	local g=vgf.SelectMatchingCard(HINTMSG_CONFIRM,e,tp,cm.filter3,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	vgf.Sendto(LOCATION_DECK,g,nil,SEQ_DECKTOP,REASON_COST)
end

function cm.con1(e)
    local tp = e:GetHandlerPlayer()
    return vgf.IsExistingMatchingCard(cm.filter2,tp,LOCATION_CIRCLE,0,3,nil) and vgf.RMonsterCondition(e) and Duel.GetTurnPlayer()==tp
end

function cm.filter2(c)
    return c:IsSetCard(0xa013) and vgf.RMonsterFilter(c)
end

function cm.filter3(c)
    return c:IsSetCard(0xa013) and c:IsType(TYPE_NORMAL+TYPE_MONSTER)
end