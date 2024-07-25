-- 【自】：你的RIDE阶段中这张卡被从手牌舍弃时，你可以将这张卡CALL到R上。
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,loc,EFFECT_TYPE_SINGLE,EVENT_DISCARD,cm.operation,vgf.True,cm.condition)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_STANDBY
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if vgf.IsCanBeCalled(c,e,tp) then
		vgf.Sendto(LOCATION_MZONE,c,0,tp)
	end
end