local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation,cm.cost,cm.con)
	vgd.GlobalCheckEffect(c,m,EVENT_SPSUMMON_SUCCESS,cm.checkcon)
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_SELFRIDE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=0
	if c:GetFlagEffect(m)>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
		a=Duel.SelectOption(tp,vgf.Stringid(m,0),vgf.Stringid(m,1))
	end
	if a==0 then Duel.Draw(tp,1,REASON_EFFECT) else vgf.AtkUp(c,c,5000) vgf.StarUp(c,c,1) end
end
function cm.filter(c)
	return vgf.RMonsterFilter(c) and c:IsLevel(3)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,4,nil) and vgf.RMonsterCondition(e)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,chk) and vgf.OverlayCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	end
	vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	vgf.OverlayCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
end