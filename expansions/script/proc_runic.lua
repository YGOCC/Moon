--created by SlientKnight, coded by Kinny
--Not yet finalized values
--Custom constants

--Track
g_RP={0,0}
g_RP[0]=0
g_RP[1]=0

--Custom Functions
function Duel.GetRP(player)
	return g_RP[player]
end
function Duel.SetRP(player, rp)
	_r = g_RP
	g_RP[player] = rp
	--Duel.Hint(HINT_NUMBER,player,rp)
	Duel.AnnounceNumber(player,rp)
	return _r
end
function Duel.CheckRPCost(player, rp)
	return g_RP[player] >= rp
end
function Duel.PayRPCost(player, rp)
	value = g_RP[player] - rp
	Duel.SetRP(player,value)
end
function Duel.GainRP(player, rp)
	value = g_RP[player] + rp
	Duel.SetRP(player,value)
end

function Auxiliary.EnableRunicPower(c)
	--[[if not runic_global_check then
		runic_global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetRange(0xff)
		ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge1:SetOperation(Auxiliary.runicreg)
		c:RegisterEffect(ge1,tp)
	end]]

end
function Auxiliary.runicreg(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,557)
	Duel.Remove(token,POS_FACEUP,REASON_RULE)
end
