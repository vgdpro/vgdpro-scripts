-- 冷澈的词意 芙洛尔
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	-- 【自】：这个单位从手牌登场到R时，公开你的牌堆顶的1张卡，那张卡是等级2以外的单位卡的话，将那张卡CALL到不存在单位的R上。没有CALL出场的话，将被公开的卡放置到牌堆底。
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,1)
	Duel.ConfirmCards(tp,g)
	Duel.ConfirmCards(1-tp,g)
	local ctop=g:GetFirst()
	if ctop:IsType(TYPE_MONSTER) and ctop:GetLevel()~=2 and vgf.IsCanBeCalled(ctop,e,tp) then
		vgf.Sendto(LOCATION_MZONE,ctop,0,tp,"NoMonster")
	else
		Duel.MoveSequence(ctop,1)
	end
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    return vgf.RSummonCondition(e) and c:IsPreviousLocation(LOCATION_HAND)
end