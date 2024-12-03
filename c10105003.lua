local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,vgf.CardsFromTo(REASON_EFFECT,LOCATION_HAND,LOCATION_DECK,cm.filter),nil,vgf.VSummonCondition)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation1,cm.cost,cm.condition)
end
function cm.filter(c)
	return c:IsSetCard(0x3040)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not cm.condition(e,tp,eg,ep,ev,re,r,rp) and vgf.IsExistingMatchingCard(cm.filter1,tp,LOCATION_ORDER,0,1,nil)
end
function cm.filter1(c)
	return c:GetFlagEffect(FLAG_IMPRISON)>0
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return vgf.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_DAMAGE,0,1,nil) and vgf.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil,nil):GetFirst():GetOverlayCount()>=1 end
	local g1=vgf.SelectMatchingCard(HINTMSG_DAMAGE,e,tp,Card.IsFaceup,tp,LOCATION_DAMAGE,0,1,1,nil)
	Duel.ChangePosition(g1,POS_FACEDOWN)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local g2=vgf.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst():GetOverlayGroup():Select(tp,1,1,nil)
	vgf.Sendto(LOCATION_DROP,g2,REASON_COST)
end