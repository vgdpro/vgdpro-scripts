--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.OverDress(c,10101009)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation,nil,cm.condition)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=vgf.AtkUp(c,c,5000,nil)
	vgf.EffectReset(c,e1,EVENT_BATTLED)
	if Duel.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil,nil):GetFirst():GetOverlayCount()>=2 and Duel.SelectEffectYesNo(tp,vgf.stringid(VgID,10)) then
		local cg=Duel.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst():GetOverlayGroup():Select(tp,2,2,nil)
        if vgf.Sendto(LOCATION_DROP,cg,REASON_COST)==2 then
			local g=vgf.SelectMatchingCard(HINTMSG_LEAVEONFIELD,e,tp,vgf.RMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
			if g then
				Duel.HintSelection(g)
				vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
			end
		end
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.RMonsterCondition(e) and c:GetFlagEffectLabel(ConditionFlag)==201 and vgf.VMonsterFilter(Duel.GetAttackTarget())
end