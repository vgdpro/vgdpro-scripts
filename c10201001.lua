local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.AddRideMaterialCode(c,m,10406013)
	vgf.AddRideMaterialSetCard(c,m,0xc014,0x74)
	vgd.action.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 5000, cm.con)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op,cm.cost,vgf.con.IsV)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(FLAG_SUPPORTED)>0 and Duel.GetAttacker()==e:GetHandler() and vgf.con.IsR(e)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return vgf.cost.SoulBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk) and vgf.cost.Discard(1)(e,tp,eg,ep,ev,re,r,rp,chk) end
	vgf.cost.SoulBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	vgf.cost.Discard(1)(e,tp,eg,ep,ev,re,r,rp,chk)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.GetMatchingGroup(cm.filter,tp,LOCATION_CIRCLE,0,nil)
    Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	for tc in vgf.Next(g) do
    tc:RegisterFlagEffect(FLAG_SUPPORT,RESET_EVENT+RESETS_STANDARD,0,1)
	end
    c:RegisterFlagEffect(FLAG_SUPPORTED,RESET_EVENT+RESETS_STANDARD,0,1)
    Duel.RaiseEvent(g,EVENT_CUSTOM+EVENT_SUPPORT,e,0,tp,tp,0)
end
function cm.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsSkill(SKILL_BOOST) and c:IsRearguard()end