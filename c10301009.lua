local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,vgf.OverlayCost(1),vgf.RMonsterCondition)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=vgf.ReturnCard(g)
	Duel.DisableShuffleCheck()
	local off=1
    local ops={}
	local a=tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and vgf.GetAvailableLocation(tp)>0
	local b=tc:IsAbleToHand()
	if not a and not b then return end
    if a then
        ops[off]=1152
        off=off+1
    end
    if b then
        ops[off]=1190
        off=off+1
    end
    local sel=Duel.SelectOption(tp,table.unpack(ops))
	if sel==0 and a then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	else
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tg=vgf.SelectMatchingCard(HINTMSG_DISCARD,e,tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil,REASON_EFFECT)
		Duel.SendtoGrave(tg,REASON_COST)
	end
end