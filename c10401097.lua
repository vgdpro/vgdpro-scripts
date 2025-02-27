local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op,vgf.cost.CounterBlast(2),cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_CIRCLE+LOCATION_DROP,0,3,nil,3)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		vgf.StarUp(c,c,1)
	end
end