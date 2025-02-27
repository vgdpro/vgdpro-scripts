local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAct(c,m,LOCATION_CIRCLE,cm.operation,vgf.cost.CounterBlast(2),cm.condition,nil,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		vgf.AtkUp(c,c,10000,nil)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRearguard() and vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_CIRCLE,0,1,nil)
end
function cm.filter(c)
	return vgf.filter.IsV and c:IsSetCard(0x77)
end