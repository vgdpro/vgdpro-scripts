local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.SetOrder(c)
	vgd.AbilityAuto(c,m,LOCATION_ORDER,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SING,cm.op,nil,cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Draw(tp,1,REASON_EFFECT)
	local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,vgf.filter.IsV,tp,LOCATION_CIRCLE,0,1,1,nil)
	vgf.AtkUp(c,g,5000)
	Duel.ChangePosition(c,POS_FACEDOWN_ATTACK)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end