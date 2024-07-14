--阳光之惩戒
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
--通过【费用】[使用1张以上的你希望的张数的卡进行计数爆发]施放！
--由于这个费用支付的计数爆发1每有1张，选择对手的1张后防者，退场。
vgd.SpellActivate(c,m,cm.op,vgf.DamageCost())
end


function cm.op(e,tp,eg,ep,ev,re,r,rp)
	
end
