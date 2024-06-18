--相互面对，共渡难关
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgf.VgCard(c)
	-- 你的先导者是「双翼的大天使 阿蕾斯缇耶尔」的话能施放！
    -- 选择1个正在被攻击的单位，你的等级是奇数的后防者每有1张，这次战斗中，被选择的单位的力量+5000。这个回合中，你的等级是偶数的单位将要从R或G退场之际，你也可以不将那些卡放置到弃牌区，而是将那些卡放置到灵魂里。
    vgd.QuickSpell(c,cm.op)--,nil,cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return VgF.GetVMonster(tp):IsCode(10501002)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Group.FromCards(Duel.GetAttackTarget())
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
        g=g:FilterSelect(tp,Card.IsCanBeEffectTarget,1,1,nil,e)
        local ct=Duel.GetMatchingGroupCount(cm.filter,tp,LOCATION_MZONE,0,c)
        local atk=5000*ct
        local e1=vgf.AtkUp(c,g,atk)
        vgf.EffectReset(c,e1,EVENT_BATTLED)
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(m)
    e1:SetTargetRange(1,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function cm.filter(c)
    return c:GetLevel()%2==0
end