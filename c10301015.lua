local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.SetOrder(c)
	vgd.AbilityAct(c,m,LOCATION_ORDER,cm.operation,vgf.DamageCost(2),nil,nil,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_VMONSTER,e,tp,vgf.VMonsterFilter,tp,LOCATION_MZONE,0,1,1,nil)
	vgd.AbilityCont(c, m, LOCATION_MZONE, EFFECT_TYPE_FIELD, EFFECT_UPDATE_ATTACK, 5000, nil, cm.tg, LOCATION_MZONE, 0, RESET_PHASE+PHASE_END, g:GetFirst()
end
function cm.tg(e,c)
	return vgf.RMonsterFilter(c)
end