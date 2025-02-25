local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,vgf.cost.And(vgf.cost.CounterBlast(1),vgf.cost.Discard(1)),cm.condition)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=vgf.GetVMonster(tp)
	return vgf.RSummonCondition(e) and c:IsSummonLocation(LOCATION_HAND) and tc:IsCode(10401008,10401046)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetDecktopGroup(tp,2)
    Duel.ConfirmCards(tp,g)
	Duel.DisableShuffleCheck()
	local ct=bit.ReturnCount(vgf.GetAvailableLocation(tp))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CALL)
	local sg=g:FilterSelect(tp,vgf.IsCanBeCalled,0,ct,nil,e,tp)
	if sg:GetCount()>0 then
		vgf.Sendto(LOCATION_CIRCLE,sg,0,tp)
		g:Sub(sg)
	end
	if g:GetCount()>1 then
		Duel.SortDecktop(tp,tp,#g)
	end
end