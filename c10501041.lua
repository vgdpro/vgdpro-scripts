local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAct(c,m,LOCATION_R_CIRCLE,cm.op,vgf.CostAnd(vgf.DamageCost(1), vgf.ToOverlayCost))
	vgd.CannotBeTarget(c, m, LOCATION_V_CIRCLE, EFFECT_TYPE_SINGLE, nil, vgf.DarkWing)
	vgd.CannotBeAttackTarget(c, m, LOCATION_V_CIRCLE, EFFECT_TYPE_SINGLE, cm.val, vgf.DarkWing)
end
function cm.val(e,c)
	return vgf.RMonsterFilter(c)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.Draw(0,1)(e,tp,eg,ep,ev,re,r,rp)
	local g = vgf.SelectMatchingCard(HINTMSG_SELF,e,tp,LOCATION_BIND,0,0,1,nil)
	vgf.LevelUp(c,g,1)
end