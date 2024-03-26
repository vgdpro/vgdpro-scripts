--
local cm,m,o=GetID()
function cm.initial_effect(c)
	VgD.Rule(c)
	VgD.RideUp(c)
	VgD.CallToR(c)
	VgD.MonsterBattle(c)
	VgD.CardTrigger(c,nil)
end