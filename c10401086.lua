local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c, m,nil,nil,EVENT_TO_G_CIRCLE,cm.op,vgf.CounterBlast(1))
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local val=0
	if Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_NIGHT) then val=5000
	elseif Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_DEEP_NIGHT) then val=10000
	end
	vgf.DefUp(c,c,val)
end