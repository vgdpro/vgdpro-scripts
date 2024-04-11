--斧钺的骑士 拉夫尔克
local cm,m,o=GetID()
function cm.initial_effect(c)
    VgF.VgCard(c)
    --【起】【R】：通过【费用】[将这个单位放置到灵魂里]，选择你的1张等级3的后防者，这个回合中，力量+10000。
    vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,cm.operation,cost,RMonsterCondition)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
local g=Duel.SelectMatchingCard(tp,vgf.RMonsterCondition,tp,LOCATION_MZONE,0,1,1,nil)
--这里不会写选择等级三的后防者，只写了选择后防者
if g then
    Duel.Hintselectgion(g)
    VgF.AtkUp(c,g,10000,nil)
end