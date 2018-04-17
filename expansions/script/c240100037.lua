--created & coded by Lyris, art from Chaotic's "Oiponts Claws"
--集いし襲雷
function c240100037.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DRAW)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,240100037+EFFECT_COUNT_CODE_OATH)
	e0:SetOperation(c240100037.activate)
	c:RegisterEffect(e0)
	if c240100037.counter==nil then
		c240100037.counter=true
		c240100037[0]=0
		c240100037[1]=0
		local g=Group.CreateGroup()
		g:KeepAlive()
		c240100037[2]=g
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c240100037.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_DESTROYED)
		e3:SetOperation(c240100037.addcount)
		Duel.RegisterEffect(e3,0)
	end
end
function c240100037.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c240100037[0]=0
	c240100037[1]=0
	c240100037[2]:Clear()
end
function c240100037.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsPreviousLocation(LOCATION_MZONE) and tc:IsPreviousSetCard(0x7c4) then
			local p=tc:GetPreviousControler()
			c240100037[p]=c240100037[p]+1
			c240100037[2]:AddCard(tc)
		elseif tc:IsSetCard(0x7c4) and tc:IsType(TYPE_MONSTER) then
			local p=tc:GetPreviousControler()
			c240100037[p]=c240100037[p]+1
			c240100037[2]:AddCard(tc)
		end
		tc=eg:GetNext()
	end
end
function c240100037.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c240100037.droperation)
	Duel.RegisterEffect(e1,tp)
end
function c240100037.droperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,240100037)
	Duel.Draw(tp,c240100037[2]:GetClassCount(Card.GetCode),REASON_EFFECT)
end
