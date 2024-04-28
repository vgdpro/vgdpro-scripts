--贪欲堆积者
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	--【自】【R】：这个单位支援等级2以上的单位时，你可以灵魂填充1。
	--时点需要改成支援时
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SUPPORT,cm.operation,VgF.True,cm.condition)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.DisableShuffleCheck()
	Duel.Overlay(VgF.GetVMonster(tp),Duel.GetDecktopGroup(tp,1))
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsLevelAbove(3) and eg:GetFirst()==e:GetHandler()
end