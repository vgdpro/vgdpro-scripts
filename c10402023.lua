local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.CannotBeTarget(c,m,vgf.RMonsterCondition,nil,LOCATION_MZONE,cm.tg)
end
function cm.tg(e,tc)
	local c=e:GetHandler()
	return vgf.FrontFilter(tc) and vgf.GetColumnGroup(c):IsContains(tc) and tc:IsControler(c:GetControler())
end