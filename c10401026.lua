--突贯龙 猛击三角龙
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)

--【自】【R】：你的先导者攻击时，对手的后防者在2张以下的话，通过【费用】[将这个单位放置到灵魂里]，选择你的1张先导者，这次战斗中，☆+1。
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_ATTACK_ANNOUNCE,cm.operation2,cm.cost,cm.condition2)
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttacker()
	return vgf.RMonsterCondition(e) and vgf.GetMatchingGroupCount(vgf.RMonsterFilter,tp,0,LOCATION_CIRCLE,nil)<=2 and vgf.VMonsterFilter(c)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsRelateToEffect(e) end
    local rc=vgf.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_CIRCLE,0,nil):GetFirst()
	vgf.Sendto(LOCATION_SOUL,c,rc)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_CRITICAL_STRIKE,e,tp,vgf.VMonsterFilter,tp,LOCATION_CIRCLE,0,1,1,nil)
	if g:GetCount()>0 then
		local e1=vgf.StarUp(c,g,1,nil)
		vgf.EffectReset(c,e1,EVENT_BATTLED)
    end
end