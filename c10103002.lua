--天枪的骑士 勒克斯
local cm,m,o=GetID()
function cm.initial_effect(c)
    VgF.VgCard(c)
    --【自】：这个单位被「顶峰天帝 巴斯提昂」RIDE时，通过【费用】[将手牌中的3张等级3的卡公开]，抽1张卡。
    vgd.BeridedByCard(c,m,10103001,cm.operation,cost)
    --未写公开三张等级三的卡
    --未写永效果
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end