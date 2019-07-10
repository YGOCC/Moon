--Conjoint Sorceress
function c16000989.initial_effect(c)
	aux.AddOrigEvoluteType(c)
	c:EnableReviveLimit()
	aux.AddEvoluteProc(c,nil,5,c16000989.filter1,c16000989.filter1)  
	--Conjoint Procedure
	aux.AddOrigConjointType(c)
	aux.EnableConjointAttribute(c,5)
	--When this card is Evolute Summoned:You can Conjoint 1 monster from your hand to this card. (HOpT)
	--If this card is Conjointed with another card: You can remove 4 E-C from this card; Special Summon 2 monsters from your Deck with the Same name of the Conjoint momster to this card, also negate their effects, and cannot be used as Materials for a Summon, except Evolute Materials for a Summon. (HOpT)
end
function c16000989.filter1(c,ec,tp)
	return not c:IsType(TYPE_TOKEN)
end
