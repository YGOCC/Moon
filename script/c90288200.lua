--Pandemoniumgraph Berserker 
function c90288200.initial_effect(c)
   --setting pandemonium
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90288200,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c90288200.condition)
	e1:SetOperation(c90288200.operation)
	c:RegisterEffect(e1)
	if not c90288200.global_check then
	--Pandemonium
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetLabel(326)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c90288200.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c90288200.pandemonium=true
c90288200.pandemonium_lscale=8
c90288200.pandemonium_rscale=1
function c90288200.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,e:GetLabel())
	Duel.CreateToken(1-tp,e:GetLabel())
end
function c90288200.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c90288200.filter(c,ignore)
	return c:IsSetCard(0xCF80) and c:IsType(TYPE_MONSTER) and not c:IsCode(90288200) and c:IsSSetable(ignore)
end
function c90288200.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c90288200.filter,tp,LOCATION_DECK,0,1,1,nil,false)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end