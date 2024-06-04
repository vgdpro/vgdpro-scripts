--探寻心动 罗洛涅萝尔
local cm,m,o=GetID()

function cm.initial_effect(c)
    vgf.VgCard(c)
    -- 【自】：这个单位被RIDE时，选择你的牌堆或手牌中的至多1张等级1的歌曲卡，公开后放置到指令区，从牌堆探寻了的话，牌堆洗切。从手牌放置了的话，抽卡1张。
    vgd.BeRidedByCard(c,m,nil,cm.operation,nil,nil)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=vgf.SelectMatchingCard(HINTMSG_TOFIELD,e,tp,cm.filter,tp,LOCATION_HAND+LOCATION_DECK,0,0,1,nil)
    if #g>0 then
        local tc=g:GetFirst()
        local chk=tc:IsLocation(LOCATION_HAND)
        Duel.Sendto(tc,tp,LOCATION_ORDER,POS_FACEUP_ATTACK,REASON_EFFECT)
        Duel.ShuffleDeck(tp)
        if chk then
            Duel.Draw(tp,1,REASON_EFFECT)
        end
    end
end
function cm.filter(c)
    return c:IsSetCard(0xa040) and c:IsAbleToHand() and vgf.IsLevel(c,1)
end