local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.BeRidedByCard(c,m,cm.filter,cm.op)
	vgd.AbilityAct(c,m,LOCATION_CIRCLE,cm.op1,vgf.cost.SoulBlast(1),cm.con1,nil,1)
end
function cm.filter(c)
	return c:IsSetCard(0x79)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		vgf.Sendto(LOCATION_CIRCLE,c,0,tp)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.FromCards(vgf.GetVMonster(tp))
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		g:AddCard(c)
	end
	vgf.AtkUp(c,g,5000)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return vgf.RMonsterCondition(e) and vgf.GetVMonster(tp):IsSetCard(0x79)
end