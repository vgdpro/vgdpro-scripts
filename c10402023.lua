local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.CannotBeTarget(c,m,LOCATION_R_CIRCLE,EFFECT_TYPE_FIELD,nil,nil,cm.tg)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANMOVE_PARALLEL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(vgf.RMonsterCondition)
	e1:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e1)
end
function cm.tg(e,tc)
	local c=e:GetHandler()
	return vgf.FrontFilter(tc) and vgf.GetColumnGroup(c):IsContains(tc) and tc:IsControler(c:GetControler())
end