local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation,vgf.cost.SoulBlast(1),cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.con.IsR(e) and vgf.BlackWings(e)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.op.SoulCharge(1)(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_RMONSTER,e,tp,Card.IsRearguard,tp,0,LOCATION_CIRCLE,1,1,nil)
	local tc=vgf.ReturnCard(g)
	if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabel(e:GetHandlerPlayer())
		e1:SetCondition(cm.con1)
		tc:RegisterEffect(e1)
		vgf.effect.Reset(c,e1,EVENT_PHASE+PHASE_DRAW,cm.con2,e:GetHandlerPlayer())
	end
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_DRAW and Duel.GetTurnPlayer(tp)~=e:GetLabel()
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer(tp)~=e:GetLabel()
end