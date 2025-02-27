-- 满载甜品 安泽尔玛
local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 【自】【后列的R】【1回合1次】：你的战斗阶段中你其他的单位登场到R时，通过【费用】[灵魂爆发2]，抽1张卡。
	VgD.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_SPSUMMON_SUCCESS,vgf.op.Draw,vgf.cost.SoulBlast(2),cm.con,nil,1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    local ph = Duel.GetCurrentPhase()
    return c:IsBackrow() and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and Duel.GetTurnPlayer() == tp and eg:IsExists(cm.filter,1,c,tp)
end
function cm.filter(c,tp)
	return c:IsRideOnRCircle() and c:IsControler(tp)
end