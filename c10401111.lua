local cm,m,o=GetID()
--怨念锁
function cm.initial_effect(c)
	vgd.VgCard(c)
	--【起】【V】【1回合1次】：通过【费用】[灵魂爆发1]，抽2张卡，
	--选择你的手牌中的至多1张指令卡，舍弃，没有舍弃的话，选择手牌中的的2张卡舍弃。
	vgd.AbilityAct(c,m,LOCATION_MZONE,cm.operation,vgf.OverlayCost(1),vgf.VMonsterCondition,nil,1)
	--【永】【R】：这个回合中你施放过指令卡的话，这个单位的力量+2000。
	vgd.AbilityCont(c, m, LOCATION_MZONE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 2000, cm.con)
	vgd.GlobalCheckEffect(c,m,EVENT_CHAINING,cm.checkcon)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.Draw(tp,2,REASON_EFFECT)
	if vgf.CardsFromTo(REASON_EFFECT,LOCATION_HAND,LOCATION_DROP,cm.filter,1,0)(e,tp,eg,ep,ev,re,r,rp)==0 then
		vgf.CardsFromTo(REASON_EFFECT,LOCATION_HAND,LOCATION_DROP,nil,2,2)(e,tp,eg,ep,ev,re,r,rp)
	end
end
function cm.filter(c)
	return c:IsType(TYPE_SPELL)
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0 and vgf.RMonsterCondition(e)
end