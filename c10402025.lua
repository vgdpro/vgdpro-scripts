local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.Order(c,m,cm.op,vgf.cost.CounterBlast(1))
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,2)
	vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
	local ct=bit.ReturnCount(vgf.GetAvailableLocation(tp))
	if vgf.GetVMonster(tp):IsCode(10104001) then if ct>2 then ct=2 end
	else if ct>1 then ct=1 end
	end
	local sg=vgf.SelectMatchingCard(HINTMSG_CALL,e,tp,cm.filter,tp,LOCATION_DROP,0,0,ct,nil,vgf.GetVMonster(tp):GetLevel(),e,tp)
	if sg:GetCount()>0 then vgf.Sendto(LOCATION_CIRCLE,sg,0,tp) end
end
function cm.filter(c,lv,e,tp)
	return c:IsLevelBelow(lv) and vgf.IsCanBeCalled(c,e,tp)
end