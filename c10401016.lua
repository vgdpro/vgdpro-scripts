local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgf.AddEffectWhenTrigger(c,m,cm.op)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(10000)
	e1:SetCondition(vgf.PlayerEffect)
	e1:SetTarget(cm.tg)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_LSCALE)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
end
function cm.tg(e,c)
	return vgf.VMonsterFilter(c)
end