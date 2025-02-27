local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,vgf.cost.SoulBlast(1),cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.con.RideOnRCircle(e) and vgf.GetVMonster(tp):IsSetCard(0x78)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        vgf.AtkUp(c,c,10000,nil)
    end
	if vgf.cost.And(vgf.cost.SoulBlast(1),vgf.cost.Retire(vgf.filter.IsR,1,1,c))(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectEffectYesNo(tp,vgf.stringid(VgID,10)) then
		Duel.BreakEffect()
		vgf.cost.And(vgf.cost.SoulBlast(1),vgf.cost.Retire(vgf.filter.IsR,1,1,c))(e,tp,eg,ep,ev,re,r,rp,0)
		local g=Duel.GetDecktopGroup(tp,5)
		Duel.ConfirmCards(tp,g)
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CALL)
		local sg=g:FilterSelect(tp,cm.filter,0,1,nil,e,tp)
		if sg:GetCount()>0 then
			vgf.Sendto(LOCATION_CIRCLE,sg,0,tp)
		end
		Duel.ShuffleDeck(tp)
	end
end
function cm.filter(c,e,tp)
	return vgf.IsCanBeCalled(c,e,tp) and c:IsLevelBelow(1)
end