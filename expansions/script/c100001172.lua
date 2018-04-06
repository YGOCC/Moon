 --Created and coded by Rising Phoenix
function c100001172.initial_effect(c)
c:SetUniqueOnField(1,0,100001172)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x75C),aux.NonTuner(Card.IsSetCard,0x75C),1)
	c:EnableReviveLimit()
		local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100001172,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
		e1:SetCountLimit(1,100001172+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c100001172.tdop)
		e1:SetTarget(c100001172.sptg)
	c:RegisterEffect(e1)
	local e13=e1:Clone()
	e13:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e13)
	local e7=e1:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
			--xyzlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--half damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetCondition(c100001172.dxcon)
	e4:SetOperation(c100001172.dxop)
	c:RegisterEffect(e4)
		--immune
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(100001172,0))
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e10:SetCode(EVENT_TO_DECK)
	e10:SetRange(LOCATION_GRAVE)
	e10:SetCondition(c100001172.spcon)
		e10:SetTarget(c100001172.target)
	e10:SetOperation(c100001172.operation)
	c:RegisterEffect(e10)
			--linklimit
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e13:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e13:SetValue(1)
	c:RegisterEffect(e13)
end
function c100001172.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100001172.tdop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Draw(tp,1,REASON_EFFECT)
end
function c100001172.filter(c,e,tp)
	return c:IsCode(100000956) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) 
end
function c100001172.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_EXTRA) and c100001172.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100001172.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100001172.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100001172.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c100001172.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and re and re:GetHandler():IsCode(100000956)
end
function c100001172.dxcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and (c==Duel.GetAttacker() or c==Duel.GetAttackTarget())
end
function c100001172.dxop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end