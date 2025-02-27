local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op,vgf.cost.CounterBlast(1),cm.con)
end
function cm.con(e)
	local c=e:GetHandler()
	return c:IsBackrow()end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,vgf.filter.IsR,tp,LOCATION_CIRCLE,0,1,1,c)
	vgf.AtkUp(c,g,c:GetAttack())
end