local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAct(c,m,LOCATION_CIRCLE,cm.op,vgf.cost.SoulBlast(1),vgf.con.IsR)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if vgf.filter.FinalRush(tp) and c:IsRelateToEffect(e) and c:IsFaceup() then
		vgf.AtkUp(c,c,5000,nil)
	end
end
function cm.aclimit(e,re,tp)
	return re:IsHasCategory(CATEGORY_DEFENDER) and re:GetHandler():IsLocation(LOCATION_CIRCLE)
end