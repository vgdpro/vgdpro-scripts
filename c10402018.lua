local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SUPPORT,cm.op,vgf.True,cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:GetFirst()==c and Duel.GetAttacker():IsCode(10000001) and vgf.RMonsterCondition(e)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		vgf.AtkUp(c,c,15000)
	end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_BATTLED)
    e1:SetCountLimit(1)
    e1:SetOperation(cm.op2)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then e:Reset() return end
	local g=vgf.GetColumnGroup(c):Filter(cm.filter,nil,tp)
	vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
	Duel.Draw(tp,1,REASON_EFFECT)
	e:Reset()
end
function cm.filter(c,tp)
	return c:IsControler(tp) and vgf.RMonsterFilter(c)
end