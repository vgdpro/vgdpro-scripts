local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,nil,vgf.con.RideOnVCircle)
	vgd.action.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 5000, cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.filter.FinalRush(tp)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CALL)
	local g=vgf.GetMatchingGroup(Card.IsVanguard,tp,LOCATION_CIRCLE,0,nil):GetFirst():GetOverlayGroup():FilterSelect(tp,Card.IsCanBeCalled,1,1,nil,e,tp,nil,nil,0x4)
	vgf.Sendto(LOCATION_CIRCLE,g,0,tp,0x4)
	vgf.op.SoulCharge(1)(e,tp,eg,ep,ev,re,r,rp)
end