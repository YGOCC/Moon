--Paintress EX Dark Witch Matissa
function c16000446.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,nil,2,2)
	c:EnableReviveLimit()
	  --duel status
 --   local e1=Effect.CreateEffect(c)
 --   e1:SetType(EFFECT_TYPE_FIELD)
 --   e1:SetRange(LOCATION_MZONE)
 ---   e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
 --   e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_DUAL))
 --   e1:SetCode(EFFECT_DUAL_STATUS)
   -- c:RegisterEffect(e1)
		  --indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c16000446.tgtg)
	e3:SetValue(c16000446.indval)
	c:RegisterEffect(e3)
				--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c16000446.tgtg)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4) 
	--race
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_REMOVED+LOCATION_HAND,0)
	e5:SetCode(EFFECT_ADD_TYPE)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_DUAL))
	e5:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e5) 
	  --spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(16000446,0))
	e6:SetCategory(CATEGORY_SUMMON)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c16000446.spcost)
	e6:SetOperation(c16000446.spop)
	c:RegisterEffect(e6)
end

function c16000446.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c16000446.tgtg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) or c:IsType(TYPE_DUAL)
end
function c16000446.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,1000) and Duel.IsExistingMatchingCard(c16000446.cfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.PayLPCost(tp,1000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c16000446.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c16000446.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c.evolute and c~=e:GetLabelObject()
end

function c16000446.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	 local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16000446.xxxfilter)
	e1:SetValue(3)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	 local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c16000446.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
end
function c16000446.xxxfilter(e,c)
	return c:IsType(TYPE_NORMAL) or c:IsType(TYPE_DUAL)
end


function c16000446.cfilter(c)
	return  c:IsFaceup() and not c:IsType(TYPE_EFFECT)  and c:IsAbleToRemoveAsCost()
end
function c16000446.splimit(e,c)
	return not c:IsSetCard(0xc50)
end

