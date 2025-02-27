local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAct(c,m,LOCATION_R_CIRCLE,cm.op,vgf.cost.And(vgf.cost.CounterBlast(1), vgf.cost.ToSoul))
	vgd.action.CannotBeTarget(c, m, LOCATION_V_CIRCLE, EFFECT_TYPE_SINGLE, nil, vgf.BlackWings)
	vgd.action.CannotBeAttackTarget(c, m, LOCATION_V_CIRCLE, EFFECT_TYPE_SINGLE, cm.val, vgf.BlackWings)
end
function cm.val(e,c)
	return vgf.filter.IsR(c)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.op.Draw(0,1)(e,tp,eg,ep,ev,re,r,rp)
	local g = vgf.SelectMatchingCard(HINTMSG_SELF,e,tp,LOCATION_BIND,0,0,1,nil)
	vgf.LevelUp(c,g,1)
end