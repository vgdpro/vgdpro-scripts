--正确的音程 克拉莉萨
local cm,m,o=GetID()
function cm.initial_effect(c)
    -- 【永】【V】：你的回合中，你没有后防者的话，这个单位的力量+5000。
	vgd.action.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 5000, cm.con1)
    --【自】：通过在「认真的挑战者 克拉莉萨」上RIDE的方式将这个单位登场到V时，通过【费用】[灵魂爆发1]，查看你的牌堆顶的7张卡，选择至多1张等级2以下的含有「诚意真心」的卡，公开后加入手牌，将其余的卡洗切后放置到牌堆底。
    vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,vgf.cost.SoulBlast(1),cm.con2)
end
function cm.con1(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return vgf.con.IsV(e) and not vgf.IsExistingMatchingCard(vgf.filter.IsR,tp,LOCATION_CIRCLE,0,1,nil) and Duel.GetTurnPlayer()==tp
end
function cm.con2(e)
    local c=e:GetHandler()
    local g=c:GetMaterial()
	return vgf.con.RideOnVCircle(e) and g:IsExists(Card.IsCode,1,nil,10501090)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetDecktopGroup(tp,7)
    Duel.ConfirmCards(tp,g)
	Duel.DisableShuffleCheck()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:FilterSelect(tp,cm.filter,0,1,nil)
	if #sg>0 then
		vgf.Sendto(LOCATION_HAND,sg,nil,REASON_EFFECT)
		g:RemoveCard(vgf.ReturnCard(sg))
	end
	while g:GetCount()>0 do
		local dg=g:RandomSelect(tp,1)
		Duel.MoveSequence(dg:GetFirst(),SEQ_DECKBOTTOM)
		g:Sub(dg)
	end
end
function cm.filter(c)
	return c:IsSetCard(0xb6) and c:IsLevelBelow(2)
end


