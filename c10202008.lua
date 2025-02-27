--贪欲堆积者
local cm,m,o=GetID()
function cm.initial_effect(c)
	--【自】【R】：这个单位支援等级2以上的单位时，你可以灵魂填充1。
	--时点需要改成支援时
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SUPPORT,vgf.op.SoulCharge(1),vgf.True,cm.condition)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsLevelAbove(2) and eg:GetFirst()==e:GetHandler()
end