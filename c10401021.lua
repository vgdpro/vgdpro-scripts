local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_BATTLED,cm.op,vgf.cost.And(vgf.cost.SoulBlast(1),vgf.cost.Retire()),cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(FLAG_SUPPORT)>0 and vgf.con.IsR(e)
end