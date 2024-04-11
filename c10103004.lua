--天弓的骑士 贝斯
--【自】：这个单位被RIDE时，你是后攻的话，抽1张
--默认内容
local cm,m,o=GetID()
function cm.initial_effect(c)
    VgF.VgCard(c)
    vgd.BeRidedByCard(c,m,nil,cm.condition)
    
end
--效果条件
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp==1 and Duel.GetTurnPlayer()==tp
    
end
--效果内容
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
    
end