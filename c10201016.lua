local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,loc,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,vgf.DamageCost(1),cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Draw(tp,1,REASON_EFFECT)
	if vgf.GetVMonster(1-tp):IsLevelAbove(4) then
		vgf.AtkUp(c,c,10000)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_HAND) and vgf.FrontFilter(c) and vgf.IsExistingMatchingCard(vgf.BackFilter,tp,LOCATION_MZONE,0,3,nil)
end