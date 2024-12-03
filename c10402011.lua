local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.EffectTypeTriggerWhenHitting(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,cm.op,cm.cost)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_LEAVEFIELD,e,tp,cm.filter,tp,0,LOCATION_MZONE,1,1,nil)
	vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
	Duel.BreakEffect()
	if vgf.GetVMonster(tp):IsCode(10101001) then
		vgf.CardsFromTo(REASON_EFFECT,LOCATION_MZONE,LOCATION_GRAVE,Card.IsLevel,1,0,0)(e,tp,eg,ep,ev,re,r,rp)
	end
end
function cm.filter(c)
	return vgf.FrontFilter(c) and vgf.RMonsterFilter(c)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,chk) and vgf.OverlayCost(1)(e,tp,eg,ep,ev,re,r,rp,chk) end
	vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	vgf.OverlayCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
end