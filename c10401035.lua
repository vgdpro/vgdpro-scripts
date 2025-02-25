local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op,cm.cost,cm.con)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SUPPORT,cm.op,cm.cost,cm.con1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.GetVMonster(tp):GetOverlayGroup()
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	g=g:Select(tp,1,1,nil)
	vgf.Sendto(LOCATION_HAND,g,nil,REASON_EFFECT)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return vgf.IsExistingMatchingCard(nil,vgf.RMonsterFilter,tp,LOCATION_CIRCLE,0,1,c) and vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,chk) end
	vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=vgf.SelectMatchingCard(HINTMSG_OVERLAY,nil,tp,vgf.RMonsterFilter,tp,LOCATION_CIRCLE,0,1,c)
	vgf.Sendto(LOCATION_SOUL,g)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffectLabel(tp,FLAG_CONDITION)==10102001
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return cm.con(e,tp,eg,ep,ev,re,r,rp) and re:GetHandler()==e:GetHandler()
end