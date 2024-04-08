--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgf.AddCodeList(c,10101009)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation2,nil,vgf.RMonsterCondition)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+m,cm.operation3,vgf.OverlayCost(2),cm.condition3)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	VgF.AtkUp(c,c,10000,nil)
	Duel.RaiseEvent(c,EVENT_CUSTOM+m,e,0,tp,tp,0)
end
function cm.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LEAVEONFIELD)
	local g=Duel.SelectTarget(tp,vgf.RMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
	if g then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cm.condition3(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst()==e:GetHandler()
end
