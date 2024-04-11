--顶峰天帝 巴斯提昂
local cm,m,o=GetID()
function cm.initial_effect(c)
    VgF.VgCard(c)
    --【自】【V】【1回合1次】：你的攻击判定将等级3的卡判出的战斗结束时，通过【费用】[将手牌中的1张卡舍弃]，选择你的1张后防者，重置，这个回合中，那个单位的力量+10000。
    vgd.EffectTyperTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_DAMAGE_STEP_END,cm.operation,vgf.DisCardCost(1),vgf.VMonsterCondition,nil,1,EFFECT_FLAG_DAMAGE_STEP)
    --【永】【V】：你的回合中，你所有的等级3的单位的力量+2000。
    
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
    local g=Duel.SelectMatchingCard(tp,vgf.RMonsterFilter,tp,LOCATION_MZONE,0,1,1,nil)
    if g then
        Duel.Hintselectgion(g)
        Duel.ChangePosition(g,POS_ATTACK)
        vgF.AtkUp(c,g,10000,nil)
    end
end

end
