--Gran Signore della Xenofiamma
--Script by XGlitchy30
function c26591136.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c26591136.splimit)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c26591136.tdcon)
	e2:SetTarget(c26591136.tdtg)
	e2:SetOperation(c26591136.tdop)
	c:RegisterEffect(e2)
	--protection
	local e3x=Effect.CreateEffect(c)
	e3x:SetType(EFFECT_TYPE_SINGLE)
	e3x:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3x:SetRange(LOCATION_MZONE)
	e3x:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3x:SetValue(aux.tgoval)
	c:RegisterEffect(e3x)
	local e3y=Effect.CreateEffect(c)
	e3y:SetType(EFFECT_TYPE_SINGLE)
	e3y:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3y:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3y:SetRange(LOCATION_MZONE)
	e3y:SetValue(aux.indoval)
	c:RegisterEffect(e3y)
end
--ritual custom procedure
function c26591136.filter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c26591136.ritual_custom_condition(c,mg,ft)
	local tp=c:GetControler()
	local g=mg:Filter(c26591136.filter,c,tp)
	return ft>-3 and g:IsExists(c26591136.ritfilter1,1,nil,c:GetLevel(),g)
end
function c26591136.ritfilter1(c,lv,mg)
	lv=lv-c:GetLevel()
	if lv<2 then return false end
	local mg2=mg:Clone()
	mg2:Remove(Card.IsAttribute,nil,c:GetAttribute())
	return mg2:IsExists(c26591136.ritfilter2,1,nil,lv,mg2)
end
function c26591136.ritfilter2(c,lv,mg)
	local clv=c:GetLevel()
	lv=lv-clv
	if lv<1 then return false end
	local mg2=mg:Clone()
	mg2:Remove(Card.IsAttribute,nil,c:GetAttribute())
	return mg2:IsExists(c26591136.ritfilter3,1,nil,lv)
end
function c26591136.ritfilter3(c,lv)
	return c:GetLevel()==lv
end
function c26591136.ritual_custom_operation(c,mg)
	local tp=c:GetControler()
	local lv=c:GetLevel()
	local g=mg:Filter(c26591136.filter,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=g:FilterSelect(tp,c26591136.ritfilter1,1,1,nil,lv,g)
	local tc1=g1:GetFirst()
	lv=lv-tc1:GetLevel()
	g:Remove(Card.IsAttribute,nil,tc1:GetAttribute())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=g:FilterSelect(tp,c26591136.ritfilter2,1,1,nil,lv,g)
	local tc2=g2:GetFirst()
	lv=lv-tc2:GetLevel()
	g:Remove(Card.IsAttribute,nil,tc2:GetAttribute())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g3=g:FilterSelect(tp,c26591136.ritfilter3,1,1,nil,lv)
	g1:Merge(g2)
	g1:Merge(g3)
	c:SetMaterial(g1)
end
--filters
function c26591136.mat_filter(c)
	return false
end
function c26591136.tdfilter(c)
	return c:IsAbleToDeck() and (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()))
end
--spsummon limit
function c26591136.splimit(e,se,sp,st)
	return e:GetHandler():IsLocation(LOCATION_HAND) and bit.band(st,SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
--shuffle
function c26591136.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c26591136.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(c26591136.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c26591136.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26591136.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end