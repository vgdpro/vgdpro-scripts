--殷切的愿望 哈那耶尔
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.CardToG(c,m,vgf.DisCardCost(1))
end