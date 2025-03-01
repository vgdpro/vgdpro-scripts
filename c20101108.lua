local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,LOCATION_R_CIRCLE,EFFECT_TYPE_FIELD,EVENT_TO_GRAVE,cm.op,nil,cm.condition,nil,1)
end
function cm.filter(c,tp)
	local tc=c:GetReasonCard()
	return c:IsPreviousLocation(LOCATION_CIRCLE) and c:IsPreviousControler(1-tp)
		and c:GetPreviousSequence()~=5 and tc
		and tc:IsControler(tp) and tc:IsLevelAbove(3) and tc:IsVanguard()
end
-- 对手的后防者由于你的等级3以上的先导者的能力退场时
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,tp)
end
-- 这个回合中，这个单位的力量+10000
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		vgf.AtkUp(c,c,10000)
	end
end