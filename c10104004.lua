--树角兽 罗特
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.BeRidedByCard(c,m,nil,cm.operation,nil,cm.condition)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp==1 and Duel.GetTurnPlayer()==tp
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end