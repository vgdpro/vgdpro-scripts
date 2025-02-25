--激发之泉
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
    -- 你的后防者在3张以上的话，这次战斗中，你所有的正在被攻击的单位的力量+15000。
	vgd.BlitzOrder(c,cm.op)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if vgf.IsExistingMatchingCard(vgf.RMonsterFilter,tp,LOCATION_CIRCLE,0,3,nil) then
        local ac=Duel.GetAttackTarget()
        local e1=vgf.AtkUp(c,ac,15000,nil)
        vgf.EffectReset(c,e1,EVENT_BATTLED)
    end
end

