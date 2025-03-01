local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,nil,cm.condition)
end
-- 你的战斗阶段中这个单位登场到R时，有等级3以上的含有「玛莉蕾恩」的先导者的话
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	local v=vgf.GetVMonster(tp)
	return Duel.GetTurnPlayer()==tp and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
		and v and v:IsLevelAbove(3) and v:IsSetCard(0x130)
		and c:IsRideOnRCircle()
end
-- 这个回合中，这个单位的力量+10000
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		vgf.AtkUp(c,c,10000)
	end
end