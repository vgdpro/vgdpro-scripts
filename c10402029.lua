local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,vgf.CardsFromTo(REASON_EFFECT,LOCATION_MZONE,LOCATION_DROP,cm.filter),vgf.DamageCost(1),vgf.RSummonCondition)
	vgd.AbilityAuto(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op,vgf.DamageCost(1),vgf.RMonsterCondition)
end
function cm.filter(c)
	return c:IsLevel(0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,Card.IsLevel,tp,LOCATION_MZONE,0,1,1,nil,0)
	vgf.AtkUp(c,g,5000)
end