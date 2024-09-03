local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op,vgf.DamageCost(2),cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_MZONE+LOCATION_GRAVE,0,3,nil,3)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		vgf.StarUp(c,c,1)
	end
end