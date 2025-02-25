--阳光之惩戒
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
--通过【费用】[使用1张以上的你希望的张数的卡进行计数爆发]施放！
--由于这个费用支付的计数爆发1每有1张，选择对手的1张后防者，退场。
	vgd.Order(c,m,cm.op,cm.cost)
	vgf.AddAlchemagicFrom(c,m,"LOCATION_DAMAGE")
	vgf.AddAlchemagicTo(c,m,"POSCHANGE")
	vgf.AddAlchemagicFilter(c,m,Card.IsFaceup)
	vgf.AddAlchemagicCountMin(c,m,1)
	vgf.AddAlchemagicCountMax(c,m,100)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=vgf.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_DAMAGE,0,nil)
	if chk==0 then
		return vgf.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_DAMAGE,0,1,nil)
	end
	local g=vgf.SelectMatchingCard(HINTMSG_DAMAGE,e,tp,Card.IsFaceup,tp,LOCATION_DAMAGE,0,1,ct,nil)
	local lab=Duel.ChangePosition(g,POS_FACEDOWN_ATTACK)
	e:SetLabel(lab)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local ct1=vgf.GetMatchingGroupCount(nil,tp,0,LOCATION_MZONE,nil)
	if ct>ct1 then ct=ct1 end
	if ct==0 then return end
	local g=vgf.SelectMatchingCard(HINTMSG_LEAVEFIELD,e,tp,nil,tp,0,LOCATION_MZONE,1,ct,nil)
	if g:GetCount()>0 then
		vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
	end
end
