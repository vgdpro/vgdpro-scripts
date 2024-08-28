local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op,vgf.DamageCost(1),cm.con)
end
function cm.con(e)
	local c=e:GetHandler()
	return vgf.BackFilter(c)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,vgf.RMonsterFilter,tp,LOCATION_MZONE,0,1,1,c)
	vgf.AtkUp(c,g,c:GetAttack())
end