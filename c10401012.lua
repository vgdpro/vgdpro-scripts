local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.EffectTypeTriggerWhenHitting(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,cm.op,cm.cost,cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local code=vgf.GetVMonster(tp):GetCode()
	vgf.CardsFromTo(REASON_EFFECT,LOCATION_HAND,LOCATION_DECK,cm.filter,1,0,code)
end
function cm.filter(c,code)
	return c:IsCode(code)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,chk) end
	vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	vgf.Sendto(LOCATION_DROP,c,REASON_COST)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(FLAG_SUPPORT)>0
end