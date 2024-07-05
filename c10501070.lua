--扎起头发的憧憬 海尔维希
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgf.VgCard(c)
    -- 【自】：你的战斗阶段中这个单位登场到R时，通过【费用】[将这个单位放置到灵魂里]，抽1张卡。
    vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,cm.cost,cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    local ph = Duel.GetCurrentPhase() 
    return not cm.condition(e,tp,eg,ep,ev,re,r,rp) and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and Duel.GetTurnPlayer() == tp
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsSummonType(SUMMON_TYPE_RIDE) or c:IsSummonType(SUMMON_TYPE_SELFRIDE)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return true end
    local rc=vgf.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
	vgf.Sendto(LOCATION_OVERLAY,c,rc)
end