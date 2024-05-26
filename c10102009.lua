local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.CardToG(c,vgf.DisCardCost(1))
end
