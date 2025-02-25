local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAct(c,m,LOCATION_MZONE,cm.op,cm.cost,cm.con)
	vgd.AbilityAuto(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_PHASE+PHASE_BATTLE_START,cm.op1,nil,cm.con1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return vgf.Rest(c)(e,tp,eg,ep,ev,re,r,rp,chk) and vgf.OverlayCost(1)(e,tp,eg,ep,ev,re,r,rp,chk) end
	vgf.OverlayCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	vgf.Rest(c)(e,tp,eg,ep,ev,re,r,rp,chk)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.RMonsterCondition(e) and vgf.GetVMonster(tp):IsCode(10401002)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_LEAVEFIELD,e,tp,vgf.RMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
	vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.Stand(c)(e,tp,eg,ep,ev,re,r,rp)
	vgf.AtkUp(c,c,5000)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return vgf.GetMatchingGroupCount(vgf.VMonsterFilter,tp,0,LOCATION_MZONE,nil)<=1
end