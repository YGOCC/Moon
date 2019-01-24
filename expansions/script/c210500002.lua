--BlackWing Extra Deck
--Somen00b was here
local card = c210500002
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
    return Duel.GetTurnCount()==1 or not Duel.GetTurnCount()==1
end
function card.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,210500002)
	Duel.Hint(HINT_CARD,0,54082269)
	local sc=Duel.CreateToken(tp,54082269)
	Duel.SendtoDeck(sc,nil,2,REASON_RULE)
	Duel.Hint(HINT_CARD,0,16051717)
	sc=Duel.CreateToken(tp,16051717)
	Duel.SendtoDeck(sc,nil,2,REASON_RULE)
	Duel.Hint(HINT_CARD,0,81983656)
	sc=Duel.CreateToken(tp,81983656)
	Duel.SendtoDeck(sc,nil,2,REASON_RULE)
	Duel.Hint(HINT_CARD,0,69031175)
	sc=Duel.CreateToken(tp,69031175)
	Duel.SendtoDeck(sc,nil,2,REASON_RULE)
	Duel.Hint(HINT_CARD,0,95040215)
	sc=Duel.CreateToken(tp,95040215)
	Duel.SendtoDeck(sc,nil,2,REASON_RULE)
	Duel.Exile(e:GetHandler(),REASON_RULE)
end