local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,cm.op,vgf.DamageCost(1),vgf.VMonsterCondition)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op1,vgf.EnergyCost(4),cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.SearchCard(LOCATION_HAND,LOCATION_DECK,cm.filter,1,0)(e,tp,eg,ep,ev,re,r,rp)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		vgf.AtkUp(c,c,10000)
	end
end
function cm.filter(c)
	return c:IsCode(m)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.VMonsterCondition(e) and vgf.VMonsterFilter(Duel.GetAttackTarget())
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_RMONSTER,e,tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.ChangePosition(g,POS_FACEUP_ATTACK)
		g:AddCard(c)
        vgf.AtkUp(c,g,10000,nil)
    end
end