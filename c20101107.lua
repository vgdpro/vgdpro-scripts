local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,0,EFFECT_TYPE_SINGLE,EVENT_DISCARD,vgf.op.Draw(),vgf.cost.SoulBlast(2),cm.condition)
end
-- 你的RIDE阶段中
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_RIDE
end