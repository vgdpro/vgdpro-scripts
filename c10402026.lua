local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAct(c,m,LOCATION_CIRCLE,cm.op,cm.cost,cm.con)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_PHASE+PHASE_BATTLE_START,cm.op1,nil,cm.con1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return vgf.op.Rest(c)(e,tp,eg,ep,ev,re,r,rp,chk) and vgf.cost.SoulBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk) end
	vgf.cost.SoulBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	vgf.op.Rest(c)(e,tp,eg,ep,ev,re,r,rp,chk)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.con.IsR(e) and vgf.GetVMonster(tp):IsCode(10401002)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_LEAVEFIELD,e,tp,Card.IsR,tp,0,LOCATION_CIRCLE,1,1,nil)
	vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.op.Stand(c)(e,tp,eg,ep,ev,re,r,rp)
	vgf.AtkUp(c,c,5000)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return vgf.GetMatchingGroupCount(Card.IsV,tp,0,LOCATION_CIRCLE,nil)<=1
end