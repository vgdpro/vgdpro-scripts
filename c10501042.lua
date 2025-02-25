-- 甘甜的音色 库莉姆希尔特
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	-- 【自】：你的战斗阶段中这个单位登场到R时，通过【费用】[灵魂爆发1]，这个回合中，这个单位的力量+10000。
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,vgf.cost.SoulBlast(1),cm.con)
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    local ph = Duel.GetCurrentPhase()
    return vgf.RSummonCondition(e) and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and Duel.GetTurnPlayer() == tp
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
        vgf.AtkUp(c,c,10000)
    end
end