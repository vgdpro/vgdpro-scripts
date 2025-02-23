local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,vgf.OverlayFill(1),nil,cm.con)
	vgd.EffectTypeIgnition(c,m,LOCATION_OVERLAY,cm.op,cm.cost)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.VMonsterFilter(Duel.GetAttackTarget())
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,chk) and vgf.LeaveFieldCost(e:GetHandler())(e,tp,eg,ep,ev,re,r,rp,chk) end
	vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	vgf.LeaveFieldCost(e:GetHandler())(e,tp,eg,ep,ev,re,r,rp,chk)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,vgf.VMonsterFilter,tp,LOCATION_MZONE,0,1,1,nil)
	vgf.AtkUp(c,g,10000)
end