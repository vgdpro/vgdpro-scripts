local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.CannotBeTarget(c,m,LOCATION_R_CIRCLE,EFFECT_TYPE_FIELD,nil,nil,cm.tg)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANMOVE_PARALLEL)
	e1:SetRange(LOCATION_CIRCLE)
	e1:SetCondition(vgf.con.IsR)
	e1:SetTargetRange(LOCATION_CIRCLE,0)
	c:RegisterEffect(e1)
end
function cm.tg(e,tc)
	local c=e:GetHandler()
	return tc:IsFrontrow() and c:IsContains(tc:GetColumnGroup()) and tc:IsControler(c:GetControler())
end