local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op,vgf.cost.CounterBlast(1),vgf.con.IsV)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	if ct>=5 then Duel.Draw(tp,1,REASON_EFFECT) end
	if ct>=10 then
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local t={vgf.AtkUp(c,c,10000),vgf.StarUp(c,c,1)}
			vgf.effect.Reset(c,t,EVENT_BATTLED)
		end
	end
	if ct>=15 then
		local g1=vgf.GetMatchingGroup(vgf.filter.IsR,tp,LOCATION_CIRCLE,0,nil)
		local g2=vgf.GetMatchingGroup(vgf.filter.IsR,tp,0,LOCATION_CIRCLE,nil)
		local tc1=vgf.GetVMonster(tp)
		local tc2=vgf.GetVMonster(1-tp)
		vgf.Sendto(LOCATION_SOUL,g1,tc1)
		vgf.Sendto(LOCATION_SOUL,g2,tc2)
		if vgf.GetAvailableLocation(tp)>0 then
			local g=tc1:GetOverlayGroup():FilterSelect(tp,vgf.IsCanBeCalled,tp,0,2,nil,e,tp)
			vgf.Sendto(LOCATION_CIRCLE,g,0,tp)
		end
	end
end