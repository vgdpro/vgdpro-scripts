--
local cm,m,o=GetID()
function cm.initial_effect(c)
    VgD.Rule(c)
    VgD.RideUp(c)
    VgD.CallToV(c)
    VgD.MonsterBattle(c)
    VgD.MonsterTrigger(c,nil)
end