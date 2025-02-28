local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityCont(c, m, LOCATION_R_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 5000, cm.con)
	vgd.action.AbilityCont(c, m, LOCATION_G_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_DEFENSE, 5000, cm.con)
	vgd.action.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,vgf.cost.SoulBlast(1),vgf.con.RideOnRCircle)
end
function cm.con(e)
	local tp=e:GetHandlerPlayer()
	return vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_ORDER,0,2,nil)
end
function cm.filter(c)
	return c:GetFlagEffect(FLAG_IMPRISON)>0
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if vgf.CheckPrison(tp) then
		local g=vgf.SelectMatchingCard(HINTMSG_OPPO,e,tp,cm.filter1,tp,0,LOCATION_CIRCLE,1,1,nil)
		vgf.SendtoPrison(g,tp)
	end
end
function cm.filter1(c)
	return c:IsRearguard() and c:IsFrontrow()
end