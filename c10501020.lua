local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.GlobalCheckEffect(c,m,EVENT_CHANGE_POS,cm.checkcon)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SUPPORT,cm.op,nil,cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,m)>0 and eg:IsContains(e:GetHandler()) and vgf.filter.IsR(c)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=vgf.AtkUp(c,c,5000,nil)
		vgf.effect.Reset(c,e1,EVENT_BATTLED)
	end
	if Card.IsSequence(c,2) then
		vgf.CounterCharge(1)(e,tp,eg,ep,ev,re,r,rp)
	end
end
function cm.checkfilter(c,tp,re)
	return c:IsLocation(LOCATION_ORDER) and c:IsSetCard(0xa040) and c:IsControler(tp) and c:IsPosition(POS_FACEDOWN) and vgf.filter.IsV(re:GetHandler())
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.checkfilter,1,nil,tp,re)
end