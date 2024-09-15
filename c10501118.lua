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
function cm.filter(c)
    return c:GetLevel()%2==1
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Group.FromCards(Duel.GetAttackTarget())
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
        g=g:FilterSelect(tp,Card.IsCanBeEffectTarget,1,1,nil,e)
        local ct=vgf.GetMatchingGroupCount(cm.filter,tp,LOCATION_MZONE,0,c)
        local atk=5000*ct
        local e1=vgf.AtkUp(c,g,atk)
        vgf.EffectReset(c,e1,EVENT_BATTLED)
    end
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EFFECT_SEND_REPLACE)
    e4:SetTarget(cm.reptg)
    e4:SetValue(cm.repval)
    e4:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e4,tp)
end
function cm.repfilter(c,tp)
    return c:IsControler(tp) and (c:IsLocation(LOCATION_GZONE) or vgf.RMonsterFilter(c)) and c:GetDestination()==LOCATION_GRAVE and c:IsType(TYPE_MONSTER) and c:IsFaceup() and not cm.filter(c)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp) end
    if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        local g=eg:Filter(cm.repfilter,nil,tp)
        local ct=g:GetCount()
        if ct>1 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
            g=g:Select(tp,1,ct,nil)
        end
        for tc in vgf.Next(g) do
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetValue(LOCATION_OVERLAY)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)
        end
        return true
    else return false end
end
function cm.repval(e,c)
    return false
end