local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAutoRided(c,m,nil,vgf.op.Draw(),nil,cm.condition)
end
-- 后攻
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==1 and Duel.GetTurnPlayer()==tp
end