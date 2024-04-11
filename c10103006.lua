--斧钺的骑士 拉夫尔克
local cm,m,o=GetID()
function cm.initial_effect(c)
    VgF.VgCard(c)
    vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,cm.operation,cm.cost,vgf.RMonsterCondition)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
    if g then
        Duel.HintSelection(g)
        VgF.AtkUp(c,g,10000,nil)
    end
end
function cm.filter(c)
    return vgf.IsLevel(c,3) and vgf.RMonsterFilter(c)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsCanOverlay() end
    local rc=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
    Duel.Overlay(rc,c)
end