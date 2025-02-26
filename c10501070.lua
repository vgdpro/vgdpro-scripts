--扎起头发的憧憬 海尔维希
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.VgCard(c)
    -- 【自】：你的战斗阶段中这个单位登场到R时，通过【费用】[将这个单位放置到灵魂里]，抽1张卡。
    vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,cm.cost,cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    local ph = Duel.GetCurrentPhase() 
    return vgf.con.RideOnRCircle(e) and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and Duel.GetTurnPlayer() == tp
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsRelateToEffect(e) end
    local rc=vgf.GetMatchingGroup(vgf.filter.IsV,tp,LOCATION_CIRCLE,0,nil):GetFirst()
	vgf.Sendto(LOCATION_SOUL,c,rc)
end