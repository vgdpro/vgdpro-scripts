local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,0,EFFECT_TYPE_SINGLE,EVENT_DISCARD,cm.operation,cm.cost,cm.condition)
end
-- 你的RIDE阶段中
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_RIDE
end
--灵魂爆发2
cm.cost=vgf.cost.SoulBlast(2)
-- 抽1张卡
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end