local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_HITTING,cm.op,nil,cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.con.IsR(e) and vgf.GetVMonster(tp):IsCode(10102001)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_CALL,e,tp,cm.filter,tp,LOCATION_SOUL,0,0,1,nil,e,tp)
	vgf.Sendto(LOCATION_CIRCLE,g,0,tp,"NoMonster")
end
function cm.filter(c,e,tp)
	return vgf.IsCanBeCalled(c,e,tp)
end