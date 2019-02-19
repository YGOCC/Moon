--Moonburst Extra Deck
--Somen00b was here
local card = c210500001
function card.initial_effect(c)	
	--activate
	local e1=Effect.CreateEffect(c)	
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1)
	e1:SetRange(0xff)
	e1:SetCondition(card.con)
	e1:SetOperation(card.op)
	c:RegisterEffect(e1)
end
function card.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()==1
end
function card.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,210500001)
	Duel.Hint(HINT_CARD,0,210424268)
	local sc=Duel.CreateToken(tp,210424268)
	Duel.SendtoDeck(sc,nil,2,REASON_RULE)
	Duel.Hint(HINT_CARD,0,210424269)
	sc=Duel.CreateToken(tp,210424269)
	Duel.SendtoDeck(sc,nil,2,REASON_RULE)
	Duel.Hint(HINT_CARD,0,210424270)
	sc=Duel.CreateToken(tp,210424270)
	Duel.SendtoDeck(sc,nil,2,REASON_RULE)
	Duel.Hint(HINT_CARD,0,210424271)
	sc=Duel.CreateToken(tp,210424271)
	Duel.SendtoDeck(sc,nil,2,REASON_RULE)
	Duel.Hint(HINT_CARD,0,210424272)
	sc=Duel.CreateToken(tp,210424272)
	Duel.SendtoDeck(sc,nil,2,REASON_RULE)
	Duel.Hint(HINT_CARD,0,210424274)
	sc=Duel.CreateToken(tp,210424274)
	Duel.SendtoDeck(sc,nil,2,REASON_RULE)
	Duel.Exile(e:GetHandler(),REASON_RULE)
end