--活力交响乐
local cm,m,o=GetID()
function cm.initial_effect(c)--这个函数下面用于注册效果
    vgf.VgCard(c)
    -- 这个回合中你的先导者被攻击击中过的话，选择1个被攻击的单位，这次战斗中，力量+30000。
    vgd.QuickSpell(c,cm.op,nil,cm.con)
    vgd.GlobalCheckEffect(c,m,EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS,EVENT_CUSTOM+EVENT_DAMAGE_TRIGGER,cm.checkcon,cm.checkop)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Group.FromCards(Duel.GetAttackTarget())
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
        g=g:FilterSelect(tp,Card.IsCanBeEffectTarget,1,1,nil,e)
        Duel.HintSelection(g)
        local e1=vgf.AtkUp(c,g,30000)
        vgf.EffectReset(c,e1,EVENT_BATTLED)
    end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
    local rc=vgf.GetVMonster(tp)
    return eg:IsContains(rc)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end