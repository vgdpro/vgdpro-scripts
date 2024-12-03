local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.EffectTypeTrigger(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,vgf.CardsFromTo(REASON_EFFECT,LOCATION_MZONE,LOCATION_OVERLAY,Card.IsSetCard,1,1,0x78),nil,vgf.VSummonCondition)
	vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,cm.op,cm.cost,nil,nil,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_LEAVEFIELD,e,tp,vgf.RMonsterFilter,tp,0,LOCATION_MZONE,2,2,nil)
	vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
	vgf.AtkUp(c,c,10000)
	vgf.StarUp(c,c,1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,chk) and vgf.IsExistingMatchingCard(vgf.RMonsterFilter,tp,LOCATION_MZONE,0,3,nil) end
	vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=vgf.SelectMatchingCard(HINTMSG_RMONSTER,e,tp,vgf.RMonsterFilter,tp,LOCATION_MZONE,0,3,3,nil)
	vgf.Sendto(LOCATION_DROP,g,REASON_COST)
end