local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,cm.op,cm.cost,vgf.VMonsterCondition)
	vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,cm.op1,vgf.OverlayCost(5),cm.con,nil,nil,nil,2)
	vgd.GlobalCheckEffect(c,m,EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS,EVENT_TO_GRAVE,cm.checkcon,cm.checkop)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENCE)
end
function cm.filter(c)
	return c:IsCanChangePosition() and c:IsPosition(POS_FACEUP_ATTACK) and vgf.RMonsterFilter(c)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LEAVEONFIELD)
	local g=Duel.SelectTarget(tp,vgf.VMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
	vgf.AtkUp(c,c,10000)
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
	local sg=g:FilterSelect(tp,Card.IsCanBeSpecialSummoned,0,ct1,nil)
	if sg:GetCount()>0 then
		vgf.Call(sg,0,tp)
		for tc in vgf.Next(sg) do g:RemoveCard(tc) end
	end
	if g:GetCount()>0 then
		local tc=vgf.GetVMonster(tp)
		Duel.Overlay(tc,g)
	end
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(1-tp)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end