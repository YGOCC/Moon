--Nasere, Supreme Heiress of Gust Vine
function c50031245.initial_effect(c)
c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,160002345,c50031245.ffilter,4,60,true,true)
		--fusion material
	--spsummon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50031245,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c50031245.con)
	e2:SetTarget(c50031245.tg)
	e2:SetOperation(c50031245.op)
	c:RegisterEffect(e2)
	--material check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c50031245.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
		--discard deck & draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c50031245.distg)
	e4:SetOperation(c50031245.drop)
	c:RegisterEffect(e4)
			--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c50031245.efilter)
	c:RegisterEffect(e5)
		--spsummon condition
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_SPSUMMON_CONDITION)
	e6:SetValue(c50031245.splimit)
	c:RegisterEffect(e6)
	--cannot release
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_UNRELEASABLE_SUM)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e9:SetValue(1)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e10)
	local e11=e9:Clone()
	e11:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e11)
--	local e12=e9:Clone()
--	e12:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
--	c:RegisterEffect(e12)
end
function c50031245.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION +0x786
end

function c50031245.ffilter(c)
	return c:IsSetCard(0x885a) and c:GetCode()~=50031245 and not c:IsCode(50031245) and not c:IsType(TYPE_FUSION) 
end
function c50031245.con(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c50031245.valcheck(e,c)
	local ct=e:GetHandler():GetMaterial():GetCount()
	e:GetLabelObject():SetLabel(ct)
end
function c50031245.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	local con3,con5,con8,con10=nil
	if ct>=5 then
		con3=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,3,nil)
	end
	if ct>=7 then
		con5=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,LOCATION_HAND,1,nil)
		local sg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,LOCATION_HAND,nil)
	end
	if ct>=9 then
		con8=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		local sg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	end

	if chk==0 then return con3 or con5 or con8 or con10 end
end
function c50031245.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct>=5 then
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_EXTRA,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	if ct>=7 then
		Duel.BreakEffect()
	local sg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,LOCATION_HAND,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
	if ct>=9 then
		Duel.BreakEffect()
	local sg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
	if ct>=11 then
		Duel.BreakEffect()
		local c=e:GetHandler()
	local g1=Duel.GetDecktopGroup(tp,10)
	local g2=Duel.GetDecktopGroup(1-tp,10)
	g1:Merge(g2)
	Duel.DisableShuffleCheck()
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	end
end
function c50031245.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,4) and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(4)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(50031245,0))
	local g=Duel.SelectTarget(tp,IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,4)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c50031245.cfilter(c)
	return c:IsSetCard(0x885a) and c:IsLocation(LOCATION_GRAVE)
end
function c50031245.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,d,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c50031245.cfilter,nil)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
		Duel.BreakEffect()
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT+REASON_RETURN)

	end
	end
end
function c50031245.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end