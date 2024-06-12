local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_BATTLED,cm.op,cm.cost,cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(SupportFlag)>0 and vgf.RMonsterCondition(e)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return vgf.OverlayCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	end
	vgf.OverlayCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	vgf.Sendto(LOCATION_DROP,c,REASON_COST)
end