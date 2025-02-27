local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,vgf.op.CardsFromTo(REASON_EFFECT,LOCATION_HAND,LOCATION_DROP,cm.filter,1,0),nil,vgf.con.RideOnVCircle)
	vgd.action.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 5000, cm.con2)
	vgd.action.GlobalCheckEffect(c,m,EVENT_CHAINING,cm.checkcon)
end
function cm.filter(c)
	return c:GetType()==TYPE_ORDER
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0 and vgf.con.IsR(e)
end