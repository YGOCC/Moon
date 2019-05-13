--Artro-Sovrano, Ultrartiglio
--Script by XGlitchy30
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--pendulum
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--ritual summon
	local p1=Effect.CreateEffect(c)
	p1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	p1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	p1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_NO_TURN_RESET)
	p1:SetCode(EVENT_TO_GRAVE)
	p1:SetRange(LOCATION_PZONE)
	p1:SetCountLimit(1)
	p1:SetCondition(cid.rtcon)
	p1:SetTarget(cid.rttg)
	p1:SetOperation(cid.rtop)
	c:RegisterEffect(p1)
	--boost atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(cid.atkcon)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,0x81))
	e1:SetValue(500)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,0x81))
	c:RegisterEffect(e2)
end
--filters
function cid.cfilter(c,tp)
	return (c:IsSetCard(0x89f) or c:IsPreviousSetCard(0x89f)) and c:GetPreviousControler()==tp and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function cid.filter(c,e,tp,m1,m2)
	if bit.band(c:GetType(),0x81)==0 or not c:IsSetCard(0x89f) or not (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then 
			return false
	end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	mg:Merge(m2)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if c:IsLocation(LOCATION_EXTRA) then
		ft=Duel.GetLocationCountFromEx(tp)
	end
	if ft>0 then	
		return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
	else
		return false
	end
end
function cid.rmfilter(c)
	return c:IsAbleToRemove() and c:IsLocation(LOCATION_HAND)
end
function cid.exfilter0(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA) and c:GetLevel()>0
end
function cid.atkfilter(c)
	return c:IsFaceup() and bit.band(c:GetType(),0x81)==0x81
end
--ritual summon
function cid.rtcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cid.cfilter,1,nil,tp)
end
function cid.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp):Filter(cid.rmfilter,nil)
		local sg=Duel.GetMatchingGroup(cid.exfilter0,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
		return e:GetHandler():IsAbleToRemove() and Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,mg1,sg)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function cid.rtop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)~=0 then
		local mg1=Duel.GetRitualMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND)
		local sg=Duel.GetMatchingGroup(cid.exfilter0,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp,mg1,sg)
		local tc=g:GetFirst()
		if tc then
			local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
			mg:Merge(sg)
			local mat=nil
			if tc:IsLocation(LOCATION_EXTRA) then
				ft=Duel.GetLocationCountFromEx(tp)
			end
			if ft>0 then
				for rem in aux.Next(mg) do
					if rem:GetRitualLevel(tc)<=0 then
						mg:RemoveCard(rem)
					end
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
				tc:SetMaterial(mat)
				Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
				tc:CompleteProcedure()
			end
		end
	end
end
--boost atk
function cid.atkcon(e)
	return Duel.IsExistingMatchingCard(cid.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end