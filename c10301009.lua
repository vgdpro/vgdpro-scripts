local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,vgf.OverlayCost(1),vgf.RMonsterCondition)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=vgf.ReturnCard(g)
	Duel.DisableShuffleCheck()
	local off=1
    local ops={}
	local a=vgf.IsCanBeCalled(tc,e,tp)
    if a then
        ops[off]=1152
        off=off+1
    end
    ops[off]=1190
    local sel=Duel.SelectOption(tp,table.unpack(ops))
	if sel==0 and a then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	else
		vgf.Sendto(LOCATION_HAND,g,nil,REASON_EFFECT)
		local tg=vgf.SelectMatchingCard(HINTMSG_DISCARD,e,tp,nil,tp,LOCATION_HAND,0,1,1,nil)
		vgf.Sendto(LOCATION_DROP,tg,REASON_EFFECT)
	end
end