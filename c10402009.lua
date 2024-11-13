local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.EffectTypeTrigger(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,vgf.OverlayCost(1),cm.con)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_BECOME_TARGET,cm.op2,nil,cm.con2,nil,1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.RSummonCondition(e) and vgf.GetVMonster(tp):IsCode(10104001)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_RMONSTER,e,tp,vgf.RMonsterFilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=vgf.ReturnCard(g)
	if tc then
		vgf.AtkUp(c,tc,5000)
		tc:RegisterFlagEffect(FLAG_ATTACK_AT_REAR,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) and vgf.VMonsterFilter(re:GetHandler()) and vgf.RMonsterCondition(e)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.AtkUp(c,c,5000)
end