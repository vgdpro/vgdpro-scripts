local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op,vgf.cost.CounterBlast(1),cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.GetVMonster(tp):IsLevel(3)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local val=5000
		if vgf.IsExistingMatchingCard(Card.IsR,tp,LOCATION_CIRCLE,0,3,c) then val=10000 end
		local e1=vgf.AtkUp(c,c,val)
		vgf.effect.Reset(c,e1,EVENT_BATTLED)
	end
end