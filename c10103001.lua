--顶峰天帝 巴斯提昂
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgf.VgCard(c)
    --【自】【V】【1回合1次】：你的攻击判定将等级3的卡判出的战斗结束时，通过【费用】[将手牌中的1张卡舍弃]，选择你的1张后防者，重置，这个回合中，那个单位的力量+10000。
    vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_BATTLED,cm.operation,vgf.DisCardCost(1),cm.condition,nil,1)
    if not cm.global_check then
        cm.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_MOVE)
        ge1:SetCondition(cm.checkcon)
        ge1:SetOperation(cm.checkop)
        Duel.RegisterEffect(ge1,0)
    end
    --【永】【V】：你的回合中，你所有的等级3的单位的力量+2000。
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetCondition(vgf.VMonsterCondition)
    e1:SetTarget(cm.target)
    e1:SetValue(2000)
    c:RegisterEffect(e1)
end
function cm.checkfilter(c,tp)
    return c:IsLocation(LOCATION_TRIGGER) and c:IsLevel(3) and c:IsControler(tp)
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.checkfilter,1,nil,tp) and Duel.GetTurnPlayer()==tp and Duel.GetAttackTarget()
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(tp,m,RESET_EVENT+EVENT_BATTLED,0,1)
end
function cm.filter(c)
    return vgf.RMonsterFilter(c) and c:IsDefensePos()
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=vgf.SelectMatchingCard(HINTMSG_RMONSTER,e,tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.ChangePosition(g,POS_FACEUP_ATTACK)
        vgf.AtkUp(c,g,10000,nil)
    end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return vgf.VMonsterCondition(e) and Duel.GetFlagEffect(tp,m)>0
end
function cm.target(e,c)
    return c:IsLevel(3) and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end