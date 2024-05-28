--激发之泉
-- 未测试
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
    -- 你的后防者在3张以上的话，这次战斗中，你所有的正在被攻击的单位的力量+15000。
	vgd.QuickSpell(c,EVENT_MOVE,cm.op,nil,nil)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
    local b = Duel.IsExistingMatchingCard(vgf.RMonsterFilter,tp,LOCATION_MZONE,0,3,c)
    if b then
        local a = Duel.GetAttackTarget()
        vgf.AtkUp(c,a,15000,EVENT_BATTLED)
    end
end

