--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.SpellActivate(c,m,vgf.SearchCard(LOCATION_DROP,cm.filter))
end
function cm.filter(c)
	return c:IsCode(10101006)
end