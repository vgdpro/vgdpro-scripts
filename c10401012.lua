local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_HITTING,cm.op,vgf.cost.And(vgf.cost.CounterBlast(1),vgf.cost.Retire()),cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local code=vgf.GetVMonster(tp):GetCode()
	vgf.op.CardsFromTo(REASON_EFFECT,LOCATION_HAND,LOCATION_DECK,cm.filter,1,0,code)
end
function cm.filter(c,code)
	return c:IsCode(code)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(FLAG_SUPPORT)>0
end