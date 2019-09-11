-- Aegis' Transformation!!

function c50000063.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c50000063.cost)
	e1:SetTarget(c50000063.target)
	e1:SetOperation(c50000063.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50000063,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,50000063)
	e2:SetCost(c50000063.spcost1)
	e2:SetTarget(c50000063.sptg1)
	e2:SetOperation(c50000063.spop1)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50000063,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,50000063)
	e3:SetCost(c50000063.spcost2)
	e3:SetTarget(c50000063.sptg2)
	e3:SetOperation(c50000063.spop2)
	c:RegisterEffect(e3)
end

function c50000063.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end

function c50000063.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local chkcost=e:GetLabel()==1
	if chk==0 then
		if chkcost then e:SetLabel(0) end
		return true
	end
	local b1=chkcost and c50000063.spcost1(e,tp,eg,ep,ev,re,r,rp,0) and c50000063.sptg1(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=chkcost and c50000063.spcost2(e,tp,eg,ep,ev,re,r,rp,0) and c50000063.sptg2(e,tp,eg,ep,ev,re,r,rp,0)
	if Duel.GetFlagEffect(tp,50000063)==0 and ft>-1
		and (b1 or b2) and Duel.SelectYesNo(tp,94) then
		local opt=0
		if b1 and b2 then
			opt=Duel.SelectOption(tp,aux.Stringid(50000063,0),aux.Stringid(50000063,1))
		elseif b1 then
			opt=Duel.SelectOption(tp,aux.Stringid(50000063,0))
		else
			opt=Duel.SelectOption(tp,aux.Stringid(50000063,1))+1
		end
		if opt==0 then
			c50000063.spcost1(e,tp,eg,ep,ev,re,r,rp,1)
		else
			c50000063.spcost2(e,tp,eg,ep,ev,re,r,rp,1)
		end
		Duel.RegisterFlagEffect(tp,50000063,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetLabel(opt+1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	else
		e:SetCategory(0)
		e:SetLabel(0)
	end
end
function c50000063.activate(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	if opt==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if opt==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c50000063.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,50000061)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c50000063.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,50000056)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
function c50000063.cfilter(c,code,ft,tp)
	return c:IsCode(code) and (ft>0 or (c:GetSequence()<5 and c:IsControler(tp))) and (c:IsFaceup() or c:IsControler(tp))
end
function c50000063.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.GetFlagEffect(tp,50000063)==0
		and Duel.CheckReleaseGroup(tp,c50000063.cfilter,1,nil,50000056,ft,tp) end
	Duel.RegisterFlagEffect(tp,50000063,RESET_PHASE+PHASE_END,0,1)
	local g=Duel.SelectReleaseGroup(tp,c50000063.cfilter,1,1,nil,50000056,ft,tp)
	Duel.Release(g,REASON_COST)
end
function c50000063.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c50000063.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c50000063.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,50000061) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c50000063.spop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c50000063.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,50000061)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c50000063.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.GetFlagEffect(tp,50000063)==0
		and Duel.CheckReleaseGroup(tp,c50000063.cfilter,1,nil,50000061,ft,tp) end
	Duel.RegisterFlagEffect(tp,50000063,RESET_PHASE+PHASE_END,0,1)
	local g=Duel.SelectReleaseGroup(tp,c50000063.cfilter,1,1,nil,50000061,ft,tp)
	Duel.Release(g,REASON_COST)
end
function c50000063.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c50000063.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,50000056) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c50000063.spop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c50000063.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,50000056)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end