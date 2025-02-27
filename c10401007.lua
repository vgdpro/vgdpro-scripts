local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,cm.cost,vgf.con.RideOnRCircle)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op1,nil,cm.con)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return vgf.cost.CounterBlast(2)(e,tp,eg,ep,ev,re,r,rp,chk) and vgf.cost.SoulBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	end
	vgf.cost.CounterBlast(2)(e,tp,eg,ep,ev,re,r,rp,chk)
	vgf.cost.SoulBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_CALL,e,tp,vgf.IsCanBeCalled,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if vgf.Sendto(LOCATION_CIRCLE,g,0,tp)>0 and g:GetFirst():IsLevel(3) then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.con.IsR(e) and vgf.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_CIRCLE+LOCATION_G_CIRCLE,0,3,nil,3)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		vgf.AtkUp(c,c,5000)
	end
end