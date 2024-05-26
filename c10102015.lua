--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.SpellActivate(c,m,vgf.OverlayFill(2))
end