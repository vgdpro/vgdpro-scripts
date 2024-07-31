local cm,m,o=GetID()
--怨念锁
function cm.initial_effect(c)
	vgf.VgCard(c)
	--【起】【V】【1回合1次】：通过【费用】[灵魂爆发1]，抽2张卡，
	--选择你的手牌中的至多1张指令卡，舍弃，没有舍弃的话，选择手牌中的的2张卡舍弃。
	vgd.EffectTypeIgnition(c,m,LOCATION_FZONE,cm.operation,vgf.OverlayCost(1),vgf.VMonsterCondition,nil,1)
	--【永】【R】：这个回合中你施放过指令卡的话，这个单位的力量+2000。
	vgd.EffectTypeContinuousChangeAttack(c,EFFECT_TYPE_SINGLE,2000,cm.con)
	vgd.GlobalCheckEffect(c,m,EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS,EVENT_CHAINING,cm.checkcon,cm.checkop)
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.Draw(tp,1,REASON_EFFECT)
	local e1=vgf.SearchCard(LOCATION_HAND,LOCATION_DROP,cm.operation1,1,0)(e,tp,eg,ep,ev,re,r,rp)
	if e1==0 then
		local e1=vgf.SearchCard(LOCATION_HAND,LOCATION_DROP,nil,2,2)(e,tp,eg,ep,ev,re,r,rp)
	end
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Card.IsType(c,TYPE_SPELL)
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0 and vgf.RMonsterCondition(e)
end