local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,cm.cost,vgf.con.RideOnVCircle)
	vgd.action.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 5000, cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return vgf.IsExistingMatchingCard(Card.IsRearguard,tp,LOCATION_CIRCLE,0,1,nil) end
	local g=vgf.SelectMatchingCard(HINTMSG_XMATERIAL,e,tp,Card.IsRearguard,tp,LOCATION_CIRCLE,0,1,1,nil)
	vgf.Sendto(LOCATION_SOUL,g,c)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffectLabel(tp,FLAG_CONDITION)==10102001
end