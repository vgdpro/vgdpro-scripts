--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.Rule(c)
	vgd.RideUp(c)
	vgd.CallToR(c)
	vgd.MonsterBattle(c)
	vgd.CardTrigger(c,nil)
end