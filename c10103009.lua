--救命天使 库拉比耶尔
local cm,m,o=GetID()
function cm.initial_effect(c)
    VgF.VgCard(c)
    vgd.CardTog(c,vgf,DisCardCostg(1))
    
end