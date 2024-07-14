--清澈的祈祷啊，旺盛燃烧吧
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.QuickSpell(c,cm.op,nil,cm.con)
end
--你的伤害区中的卡有3张以上的话，选择你的1个单位，这次战斗中，力量+15000。
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.IsExistingMatchingCard(nil,tp,LOCATION_DAMAGE,0,3,nil)
	
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	vgf.AtkUp(c,g,15000,nil)
end