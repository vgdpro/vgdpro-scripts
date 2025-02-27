local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation,nil,cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return not vgf.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_DAMAGE,0,1,nil) and vgf.con.IsR(e)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=vgf.AtkUp(c,c,5000)
	vgf.effect.Reset(c,e1,EVENT_BATTLED)
end