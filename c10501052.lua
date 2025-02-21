-- 满载甜品 安泽尔玛
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	-- 【自】【后列的R】【1回合1次】：你的战斗阶段中你其他的单位登场到R时，通过【费用】[灵魂爆发2]，抽1张卡。
	VgD.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_SPSUMMON_SUCCESS,cm.op,vgf.OverlayCost(2),cm.con,nil,1)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    local ph = Duel.GetCurrentPhase() 
    return vgf.BackFilter(c) and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and Duel.GetTurnPlayer() == tp and eg:IsExists(nil,1,c,tp)
end