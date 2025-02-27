--顶峰天帝 巴斯提昂
local cm,m,o=GetID()
function cm.initial_effect(c)
    --【自】【V】【1回合1次】：你的攻击判定将等级3的卡判出的战斗结束时，通过【费用】[将手牌中的1张卡舍弃]，选择你的1张后防者，重置，这个回合中，那个单位的力量+10000。
    vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_BATTLED,cm.operation,vgf.cost.Discard(1),cm.condition,nil,1)
    vgd.GlobalCheckEffect(c,m,EVENT_MOVE,cm.checkcon,cm.checkop)
    --【永】【V】：你的回合中，你所有的等级3的单位的力量+2000。
	vgd.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_FIELD, EFFECT_UPDATE_ATTACK, 2000, cm.con, cm.target, LOCATION_CIRCLE+LOCATION_G_CIRCLE, 0)
end
function cm.checkfilter(c,tp)
    return c:IsLocation(LOCATION_TRIGGER) and c:IsLevel(3) and c:IsControler(tp)
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttackTarget() and Duel.GetAttacker() and eg:IsExists(cm.checkfilter,1,nil,Duel.GetAttacker():GetControler())
end
function cm.filter(c)
    return vgf.filter.IsR(c) and c:IsDefensePos()
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=vgf.SelectMatchingCard(HINTMSG_RMONSTER,e,tp,cm.filter,tp,LOCATION_CIRCLE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.ChangePosition(g,POS_FACEUP_ATTACK)
        vgf.AtkUp(c,g,10000,nil)
    end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return vgf.con.IsV(e) and Duel.GetFlagEffect(tp,m)>0
end
function cm.target(e,c)
    return c:IsLevel(3) and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function cm.con(e)
    local tp=e:GetHandlerPlayer()
    return vgf.con.IsV(e) and Duel.GetTurnPlayer()==tp
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Duel.RegisterFlagEffect(Duel.GetAttacker():GetControler(),m,RESET_PHASE+PHASE_END,0,1)
    vgf.effect.Reset(e:GetHandler(),e1,EVENT_BATTLED)
end