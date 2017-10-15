--Arbor Elf
function c100782006.initial_effect(c)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100782006,0))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c100782006.spcon)
	e4:SetOperation(c100782006.spop)
	c:RegisterEffect(e4)
--to grave
local e1=Effect.CreateEffect(c)
e1:SetCategory(CATEGORY_TOGRAVE)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
e1:SetCode(EVENT_SUMMON_SUCCESS)
e1:SetTarget(c100782006.tdtg)
e1:SetOperation(c100782006.tdop)
c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c100782006.spfilter(c)
	return c:IsSetCard(0x189B7) and c:IsAbleToRemoveAsCost()
end
function c100782006.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100782006.spfilter,c:GetControler(),LOCATION_GRAVE,0,c:GetLevel(),nil)
end
function c100782006.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local lv=e:GetHandler():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100782006.spfilter,tp,LOCATION_GRAVE,0,lv,lv,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100782006.tdfilter(c)
	return c:IsSetCard(0x189B7)
end
function c100782006.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c100782006.tdfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c100782006.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100782006.tdfilter,tp,LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,tp,nil,REASON_EFFECT)
	end
end