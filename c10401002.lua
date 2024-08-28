local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,cm.op,cm.cost,vgf.VMonsterCondition)
	vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,cm.op1,vgf.OverlayCost(5),cm.con,nil,nil,nil,2)
	vgd.GlobalCheckEffect(c,m,EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS,EVENT_TO_GRAVE,cm.checkcon)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,2,nil) end
	local g=vgf.SelectMatchingCard(HINTMSG_POSCHANGE,e,tp,cm.filter,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENCE)
end
function cm.filter(c)
	return c:IsCanChangePosition() and c:IsPosition(POS_FACEUP_ATTACK) and vgf.RMonsterFilter(c)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_LEAVEONFIELD,e,tp,vgf.VMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT) end
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		vgf.AtkUp(c,c,10000)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local ct=6-Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if ct<=0 then return end
	local g=Duel.GetDecktopGroup(tp,ct)
	Duel.ConfirmCards(g)
	local ct1=vgf.GetAvailableLocation(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CALL)
	local sg=g:FilterSelect(tp,vgf.IsCanBeCalled,0,ct1,nil,e,tp)
	if sg:GetCount()>0 then
		vgf.Sendto(LOCATION_MZONE,sg,0,tp)
		g:Sub(sg)
	end
	if g:GetCount()>0 then
		local tc=vgf.GetVMonster(tp)
		vgf.Sendto(LOCATION_OVERLAY,g,tc)
	end
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(1-tp)
end