local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,0,EFFECT_TYPE_SINGLE,EVENT_DISCARD,cm.operation,nil,cm.condition)
end
-- 你的RIDE阶段中
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_RIDE
end
-- 将这张卡横置CALL到R上
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanBeCalled(e,tp,0,POS_FACEUP_DEFENSE) then
		vgf.Sendto(LOCATION_CIRCLE,c,0,tp,0x20,POS_FACEUP_DEFENSE)
	end
end