local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.CardToG(c,m,nil,vgf.DisCardCost(1))
end
