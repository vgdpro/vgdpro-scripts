--白黑的个性 阿蕾斯缇耶尔
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.action.AbilityAutoRided(c,m,nil,cm.operation,nil,cm.condition)
    -- 【自】：这个单位被RIDE时，你是后攻的话，抽1张卡。
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp==1 and Duel.GetTurnPlayer()==tp
end