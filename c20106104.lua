local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAutoRided(c,m,nil,cm.operation,nil,cm.condition)
end
-- 后攻
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==1 and Duel.GetTurnPlayer()==tp
end
-- 抽1张卡
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end