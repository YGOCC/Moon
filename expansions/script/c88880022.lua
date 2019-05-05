--Number 301: Neo CREATION-Eyes Prime Reality Dragon
function c88880022.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c88880022.xyzcon)
	e0:SetOperation(c88880022.xyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	aux.EnablePendulumAttribute(c)
	-- Pendulum effects:
	--(1) All monsters you control gain 500 ATK for card in the GY/Banished zone.
	local ep1=Effect.CreateEffect(c)
	ep1:SetType(EFFECT_TYPE_FIELD)
	ep1:SetCode(EFFECT_UPDATE_ATTACK)
	ep1:SetRange(LOCATION_PZONE)
	ep1:SetTargetRange(LOCATION_MZONE,0)
	ep1:SetCondition(c88880022.mod1condition)
	ep1:SetTarget(c88880022.mod1filter)
	ep1:SetValue(c88880022.mod1val)
	c:RegisterEffect(ep1)
	--(2) All "CREATION" monsters you control cannot be destroyed by card effects.
	local ep2=Effect.CreateEffect(c)
	ep2:SetType(EFFECT_TYPE_FIELD)
	ep2:SetCode(EFFECT_UPDATE_ATTACK)
	ep2:SetRange(LOCATION_PZONE)
	ep2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	ep2:SetTarget(c88880022.mod2filter)
	ep2:SetValue(c88880022.mod2val)
	c:RegisterEffect(ep2)
	--(3) Once per turn, if you control 1 "Number C300: CREATION-Eyes Prime Reality Dragon" and 1+ "CREATION" monster(s): you can target those monster(s); Special Summon this card using those monsters as materials. (This Special Summon is treated as an Xyz Summon.)
	-- Monster effects: 
	-- cannot be Special Summoned by other ways
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--This card's Xyz Summon cannot be negated. 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c88880022.effcon)
	c:RegisterEffect(e2)
	-- Cannot be targeted by your opponent's card effects. 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	-- If this card is Summoned: Destroy all your opponent's monsters, and if you do, all your monsters gain ATK equal to half the combined ATK of those destroyed monsters. 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(27,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c88880022.destg)
	e4:SetOperation(c88880022.desop)
	c:RegisterEffect(e4)
	-- If a monstrer would be destroyed by battle from this card: banish it instead.
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(88880022,0))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLED)
	e5:SetCondition(c88880022.condition)
	e5:SetTarget(c88880022.target)
	e5:SetOperation(c88880022.operation)
	c:RegisterEffect(e5)
	-- You can detach 1 material from this card; activate 1 of the effects of the monsters attached to this card.
	-- If your opponent's effect would Special Summon a banished monster: Negate that effect, and if you do, banish that card.
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetType(EFFECT_TYPE_ACTIVATE)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCondition(c88880022.negcondition)
	e6:SetTarget(c88880022.negtarget)
	e6:SetOperation(c88880022.negactivate)
	c:RegisterEffect(e6)
	-- Once per turn (Quick Effect): You can Normal Summon 1 "Galaxy-Eyes" monster from your GY. 
	-- Once per turn, during your opponent's Standby Phase: You opponent can banish 1 card from their hand to negate this effect, otherwise banish your opponent's monster with the highest DEF (if it's a tie, you get to choose). 
	-- If this card in the Monster Zone is destroyed: You can banish 1 card in your Pendulum Zone (if any) and then place this card in your Pendulum Zone. 
	-- If this card in the Pendulum Zone is destroyed: Place 1 of your banished Pendulum Monsters in your Pendulum Zone.
end
-- misc.
c88880022.xyz_number=301
function c88880022.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCode(88880015)
end 
function c88880022.ovfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(889)
end 
function c88880022.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c88880022.ovfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(c88880022.ovfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c88880022.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880022.ovfilter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingTarget(c88880022.ovfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=Duel.SelectMatchingCard(tp,c88880022.ovfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g2=Duel.GetMatchingGroup(tp,c88880022.ovfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	og=Group.CreateGroup()
	og:Merge(g1)
	og:Merge(g2)
	if g1:GetCount()>0 then
		local mg1=g1:GetFirst():GetOverlayGroup()
		if mg1:GetCount()~=0 then
			og:Merge(mg1)
			Duel.Overlay(g2:GetFirst(),mg1)
		end
		Duel.Overlay(g2:GetFirst(),g1)
		local mg2=g2:GetFirst():GetOverlayGroup()
		if mg2:GetCount()~=0 then
			og:Merge(mg2)
			Duel.Overlay(c,mg2)
		end
		c:SetMaterial(og)
		Duel.Overlay(c,g2:GetFirst())   
	end
end
-- functions for ep1:
function c88880022.mod1filter(e,c)
	return c:IsType(TYPE_MONSTER)
end
function c88880022.mod1val(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_GRAVE+LOCATION_REMOVED,0)*500
end
-- functions for ep2:
function c88880022.mod1condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x107b) 
end
function c88880022.mod2filter(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x107b)  -- just uncomment the part before this 
end
function c88880022.mod2val(e,c)
	return Duel.GetFieldGroupCount(c:GetControler()-1,LOCATION_REMOVED,0)*300
end
-- functions for e0:
-- functions for e2:
function c88880022.effcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
-- functions for e3:

-- functions for e4:
function c88880022.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c88880022.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		local atk=g:GetSum(Card.GetAttack)
		local c=e:GetHandler()
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		if g:GetCount()>0 and c:IsRelateToEffect(e) then
			local sc=g:GetFirst()
			while sc do
				local e0=Effect.CreateEffect(c)
				e0:SetType(EFFECT_TYPE_SINGLE)
				e0:SetCode(EFFECT_UPDATE_ATTACK)
				e0:SetValue(atk/2)
				sc:RegisterEffect(e0)
				sc=g:GetNext()
			end
		end
	end
end
-- functions for e5:
function c88880022.condition(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c88880022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
end
function c88880022.operation(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end
-- functions for e6:
function c88880022.negcondition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) and not re:GetHandler():GetFirstTarget():IsPreviousLocation(LOCATION_REMOVED) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c88880022.negtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c88880022.negactivate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,REASON_EFFECT)
	end
end 
-- functions for e7:

-- functions for e8:

-- functions for e9:

-- functions for e00: