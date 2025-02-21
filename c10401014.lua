local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op,cm.cost,cm.con,nil,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Draw(tp,1,REASON_EFFECT)
	vgf.OverlayFill(1)(e,tp,eg,ep,ev,re,r,rp)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		vgf.AtkUp(c,c,10000)
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return vgf.IsExistingMatchingCard(vgf.RMonsterFilter,tp,LOCATION_MZONE,0,1,c) end
	local g=vgf.SelectMatchingCard(HINTMSG_XMATERIAL,e,tp,vgf.RMonsterFilter,tp,LOCATION_MZONE,0,1,1,c)
	vgf.Sendto(LOCATION_OVERLAY,g)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffectLabel(tp,FLAG_CONDITION)
	return vgf.GetValueType(ct)=="number" and ct==10102001 and vgf.RMonsterCondition(e)
end