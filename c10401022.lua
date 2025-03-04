local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AdditionalEffect(c,m,cm.operation)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgd.action.Affect(c,tp,EFFECT_ALSO_CAN_TRIGGER, LOCATION_CIRCLE,function (_,tc) return tc:IsRearguard() end)
end