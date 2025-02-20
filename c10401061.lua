--忍妖 凌汛爱子
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
--【自】【R】：你的主要阶段中对手的后防者退场时，通过【费用】[将这个单位退场]，查看你的牌堆顶的1张卡，你可以将查看的单位卡CALL到R上。没有这么做的话，将其余的查看的卡放置到灵魂里。	
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,
	EFFECT_TYPE_FIELD,EVENT_TO_GRAVE,cm.op,cm.cost,cm.con)
end
--将这个单位退场
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk ==0 then
		return c:IsAbleToGraveAsCost() and e:GetHandler():IsRelateToEffect(e)
	end
	vgf.Sendto(LOCATION_DROP,c,REASON_COST)
end
--你的主要阶段中对手的后防者退场时
function cm.con(e,tp,eg,ep,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,tp) and Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.GetTurnPlayer()==tp and vgf.RMonsterCondition(e)
end
function cm.filter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(1-tp) and c:IsPreviousPosition(POS_FACEUP)
end
function cm.op(e,tp,eg,ep,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,1)
	Duel.ConfirmCards(g)
	Duel.DisableShuffleCheck()
	local sg=g:FilterSelect(tp,vgf.IsCanBeCalled,0,1,nil,e,tp)
	if sg:GetCount()>0 then
		vgf.Sendto(LOCATION_MZONE,g,0,tp)
		g:Sub(sg)
	else
		local tc=vgf.GetVMonster(tp)
		vgf.Sendto(LOCATION_OVERLAY,g,tc)
	end
end


