--Corona Charge
local ref=_G['c'..28915106]
local id=28915106
function ref.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(ref.activate)
	c:RegisterEffect(e1)
	--LP Gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(ref.lpcon)
	e3:SetOperation(ref.lpop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(ref.checkop)
	c:RegisterEffect(e4)
end
function ref.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.CoronaFilterNeo,tp,LOCATION_EXTRA,0,nil,1)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		aux.CoronaOp(tp,1,REASON_EFFECT)
	end
end

--LP Gain
function ref.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id+1)>0
end
function ref.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Recover(tp,e:GetHandler():GetFlagEffect(id+1)*500,REASON_EFFECT)
	e:GetHandler():ResetFlagEffect(id+1)
end

function ref.lpfilter(c,p)
	return c:IsType(TYPE_CORONA) and c:IsControler(p)
end
function ref.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=0
	local cg=eg:Filter(ref.lpfilter,nil,tp)
	local cc=cg:GetFirst()
	while cc do
		ct = ct + cc.aura
		cc=cg:GetNext()
	end
	if ct>0 then
		for i=1,ct do c:RegisterFlagEffect(id+1,RESET_CHAIN,0,1) end
	end
	if Duel.GetCurrentChain()==0 and c:GetFlagEffect(id+1)>0 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Recover(tp,e:GetHandler():GetFlagEffect(id+1)*500,REASON_EFFECT)
		c:ResetFlagEffect(id+1)
	end
end
