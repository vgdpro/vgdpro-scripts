--相互面对，共渡难关
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgf.VgCard(c)
	-- 你的先导者是「双翼的大天使 阿蕾斯缇耶尔」的话能施放！
    -- 选择1个正在被攻击的单位，你的等级是奇数的后防者每有1张，这次战斗中，被选择的单位的力量+5000。这个回合中，你的等级是偶数的单位将要从R或G退场之际，你也可以不将那些卡放置到弃牌区，而是将那些卡放置到灵魂里。
    vgd.QuickSpell(c,cm.op,cm.con)
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local v = VgF.GetVMonster(tp)
    return v:IsCode(10501002)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
    local g = Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.HintSelection(g)
    local a = GetMatchingGroupCount(cm.filter1,tp,LOCATION_MZONE,0)
    local b = 5000 * a
    local e1 = vgf.AtkUp(c,g,b,nil)
    vgf.EffectReset(c,e1,EVENT_BATTLED)
    -- 这个回合中，你的等级是偶数的单位将要从R或G退场之际，你也可以不将那些卡放置到弃牌区，而是将那些卡放置到灵魂
    -- 这段未实现，辛苦群主大大了~/doge
end

function cm.filter(c)
    local a = Duel.GetAttackTarget()
    return c == a
end

function cm.filter1(c)
    return vgf.IsLevel(c,1) or vgf.IsLevel(c,3)
end
