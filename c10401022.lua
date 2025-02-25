local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgf.AddEffectWhenTrigger(c,m,cm.operation)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(cm.op)
	e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.GetMatchingGroup(e,cm.filter,tp,LOCATION_CIRCLE,0,nil)
	for tc in vgf.Next(g) do
		tc:RegisterFlagEffect(FLAG_ALSO_CAN_TRIGGER,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.filter(c)
	return vgf.RMonsterFilter(c) and c:GetFlagEffect(FLAG_ALSO_CAN_TRIGGER)==0 and c:IsFaceup()
end