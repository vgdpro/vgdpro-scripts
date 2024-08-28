local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.GlobalCheckEffect(c,m,EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS,EVENT_CHANGE_POS,cm.checkcon)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SUPPORT,cm.op,nil,cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,m)>0 and eg:IsContains(e:GetHandler()) and vgf.RMonsterFilter(c)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=vgf.AtkUp(c,c,5000,nil)
		vgf.EffectReset(c,e1,EVENT_BATTLED)
	end
	if vgf.IsSequence(c,2) then
		vgf.DamageFill(1)(e,tp,eg,ep,ev,re,r,rp)
	end
end
function cm.checkfilter(c,tp,re)
	return c:IsLocation(LOCATION_ORDER) and c:IsSetCard(0xa040) and c:IsControler(tp) and c:IsPosition(POS_FACEDOWN) and vgf.VMonsterFilter(re:GetHandler())
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.checkfilter,1,nil,tp,re)
end