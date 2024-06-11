--无尽之苍蓝
local cm,m,o=GetID()
function cm.initial_effect(c)--这个函数下面用于注册效果
    vgf.VgCard(c)
    -- 选择你的1个单位，这个回合中，力量+5000。将这张卡放置到灵魂里。
    vgd.SpellActivate(c,m,cm.operation,nil)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.HintSelection(g)
	VgF.AtkUp(c,g,5000,nil)
    local rc=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
    Duel.Overlay(rc,c)
    -- 测试时发现会进魂后送墓
end
