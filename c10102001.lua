local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_RIDE_START,cm.op,nil,cm.con)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op2,vgf.OverlayCost(5),vgf.VMonsterCondition)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,ConditionFlag,RESET_PHASE+PHASE_END,0,1,m)
	local e=Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_FIELD)
	e:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e:SetCode(m)
	e:SetTargetRange(1,0)
	e:SetDescription(vgf.Stringid(m,0))
	Duel.RegisterEffect(e,tp)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and vgf.VMonsterCondition(e)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(vgf.IsSequence,tp,LOCATION_MZONE,0,nil,0,4)
	Duel.ChangePosition(g,POS_FACEUP_ATTACK)
end