local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.Order(c,m,cm.op,vgf.cost.CounterBlast(1),cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,nil,tp,LOCATION_CIRCLE,0,3,3,nil)
	vgf.AtkUp(c,g,10000)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.GetVMonster(tp):IsCode(10401009)
end