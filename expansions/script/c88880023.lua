--Dragon of Imagination: Xiangxiànglì
function c88880023.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddFusionProcCodeRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x889),3,false,true)
	--Pendulum Effects
	--(p1) All Monsters your opponents controls cannot declare a direct Attack.
	--(p2) Once Per Turn, during either players turn, If an Xyz monster would detach their Xyz Materials to Activate its effect you can banish 1 card from your hand or GY instead.
	--Monster Effects
	--(1) This card can only be destroyed by a "Number" or "CREATION" monster.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c88880023.indes)
	c:RegisterEffect(e1)
	--(2) Your opponent cannot activate trap effects while this card is face-up on the field. 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c88880023.aclimit)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	--(3) When this card destroys a monster by battle; deal 1000 points of damage to your opponent, then, gain 1000 LP.
	--(4) If this card is face-up in the Extra Deck for at least 6 Turns; you can place this card in the Pendulum Zone.
end
--Pendulum Effects
--(p1) 
--(p2)
--Monster Effects
--(1) This card can only be destroyed by a "Number" or "CREATION" monster.
function c88880023.indes(e,c)
	return not c:IsSetCard(0x48) or c:IsSetCard(0x889)
end
--(2) Your opponent cannot activate trap effects while this card is face-up on the field. 
function c88880023.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e) and re:IsType(TYPE_TRAP)
end
--(3) When this card destroys a monster by battle; deal 1000 points of damage to your opponent, then, gain 1000 LP.
--(4) If this card is face-up in the Extra Deck for at least 6 Turns; you can place this card in the Pendulum Zone.