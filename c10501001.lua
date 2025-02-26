--诚意真心的领队 克拉莉萨
local cm,m,o=GetID()
function cm.initial_effect(c)--这个函数下面用于注册效果
    vgd.VgCard(c)
    vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,vgf.op.CardsFromTo(REASON_EFFECT,LOCATION_HAND,LOCATION_DECK,cm.filter),vgf.cost.CounterBlast(1),cm.con2)
    -- 【自】【V】：这个单位的攻击击中时，抽1张卡，选择你的1张含有「诚意真心」的后防者，这个回合中，力量+5000。
    vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_HITTING,cm.operation1,nil,vgf.con.IsV)
end
function cm.con2(e)
    local c=e:GetHandler()
    local g=c:GetMaterial()
    return vgf.con.RideOnVCircle(e) and g:IsExists(Card.IsCode,1,nil,10501036)
end
function cm.filter(c)
    return c:IsCode(10501021)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Draw(tp,1,REASON_EFFECT)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
    local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,cm.filter1,tp,LOCATION_CIRCLE,0,1,1,nil)
    vgf.AtkUp(c,g,5000)
end

function cm.filter1(c)
    return c:IsSetCard(0xb6) and vgf.filter.IsR(c)
end

