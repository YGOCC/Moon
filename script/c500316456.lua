--Supa-Paintress Guerricore
--Created by Chadook
--Scripted by Chadook
function c500316456.initial_effect(c)
	
	c:EnableReviveLimit()
		--sp summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(500316456,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,0x11e0)
	e3:SetCode(EVENT_FREE_CHAIN)
	--e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c500316456.adcost)
	e3:SetTarget(c500316456.target)
	e3:SetOperation(c500316456.operation)
	c:RegisterEffect(e3)
	if not c500316456.global_check then
		c500316456.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c500316456.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c500316456.evolute=true
c500316456.material1=function(mc) return mc:IsAttribute(ATTRIBUTE_LIGHT) and mc:IsType(TYPE_NORMAL) and mc:GetLevel()==3 and mc:IsFaceup() end
c500316456.material2=function(mc) return mc:IsAttribute(ATTRIBUTE_LIGHT) and mc:IsType(TYPE_NORMAL) and mc:GetLevel()==3 and mc:IsFaceup() end
function c500316456.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,388)
	Duel.CreateToken(1-tp,388)
			c500316456.stage_o=6
c500316456.stage=c500316456.stage_o
end
function c500316456.filter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c500316456.desfilter(c)
	return c:IsFaceup() and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0 and not c:IsType(TYPE_PENDULUM) 
		and not c:IsType(TYPE_NORMAL) and c:IsDestructable()
end
function c500316456.costfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_NORMAL) and (c:IsType(TYPE_PENDULUM) and c:IsFaceup())
end
function c500316456.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1088,3,REASON_COST) and Duel.IsExistingMatchingCard(c500316456.costfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c500316456.costfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetHandler():RemoveCounter(tp,0x1088,3,REASON_COST)
end

function c500316456.cfilter(c)
	return  not c:IsType(TYPE_EFFECT) and c:IsAbleToRemoveAsCost()
end
function c500316456.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_HAND) and chkc:IsControler(tp) and c500316456.filter(chkc,e,tp) and  Duel.IsPlayerCanDraw(tp,1) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingTarget(c500316456.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c500316456.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c500316456.zzfilter(c)
	return c:IsFaceup() and  c:IsType(TYPE_EFFECT)and bit.band(tg:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsAbleToRemove() 
end
function c500316456.operation(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	if tc:IsSetCard(0xc50) and tc:IsType(TYPE_MONSTER) then
Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c500316456.zzfilter,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
end