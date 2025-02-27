local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.action.AbilityAct(c,m,LOCATION_CIRCLE,cm.op,vgf.cost.CounterBlast(1),cm.con)
	vgd.action.GlobalCheckEffect(c,m,EVENT_TO_GRAVE,cm.checkcon)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.con.IsR(e) and Duel.GetFlagEffect(tp,m)>0
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectOption(tp,vgf.Stringid(m,0),vgf.Stringid(m,1))==0 then
		if c:IsRelateToEffect(e) and c:IsFaceup() then vgf.AtkUp(c,c,10000) end
	else
		if  c:IsRelateToEffect(e) and c:IsFaceup() then vgf.Sendto(LOCATION_SOUL,c) end
		local g=vgf.SelectMatchingCard(HINTMSG_LEAVEFIELD,e,tp,cm.filter,tp,0,LOCATION_CIRCLE,1,1,nil)
		vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
	end
end
function cm.checkfilter(c,tp)
    return c:IsPreviousLocation(LOCATION_CIRCLE) and c:IsPreviousControler(1-tp) and c:IsControler(1-tp)
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.checkfilter,1,nil,tp)
end
function cm.filter(c)
	return vgf.filter.IsR(c) and c:IsLevelAbove(2)
end