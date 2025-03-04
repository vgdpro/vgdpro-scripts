local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op,cost,cm.con1)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SUPPORT,cm.op,cost,cm.con2)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local num=1
	if vgf.filter.FinalRush(tp) then num=num+1 end
	vgf.op.SoulCharge(num)(e,tp,eg,ep,ev,re,r,rp)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return vgf.con.IsR(e) and vgf.GetVMonster(tp):IsCode(10102001)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return cm.con1(e,tp,eg,ep,ev,re,r,rp) and eg:GetFirst()==e:GetHandler()
end