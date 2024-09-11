local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.CannotBeTarget(c,m,vgf.RMonsterCondition)
end