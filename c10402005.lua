local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, cm.val, vgf.con.IsR)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_BATTLED,cm.op,vgf.cost.Retire(10000001),cm.con)
end
function cm.val(e)
	local tp=e:GetHandlerPlayer()
	local val=0
	if Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_DARK_NIGHT) then val=2000
	elseif Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_ABYSSAL_DARK_NIGHT) then val=5000
	end
	return val
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.con.IsR(e) and Duel.GetAttacker()==e:GetHandler()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_LEAVEONFIELD,e,tp,Card.IsRearguard,tp,0,LOCATION_CIRCLE,0,1,nil)
	vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
end