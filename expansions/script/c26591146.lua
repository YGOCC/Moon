--Arti della Xenofiamma - Ignis
--Script by XGlitchy30
function c26591146.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,26591146)
	e1:SetTarget(c26591146.target)
	e1:SetOperation(c26591146.activate)
	c:RegisterEffect(e1)
	--inflict damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,21591146)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c26591146.drytg)
	e2:SetOperation(c26591146.dryop)
	c:RegisterEffect(e2)
end
--filters
function c26591146.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x23b9) and c:GetAttack()+c:GetDefense()>0
end
--Activate
function c26591146.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26591146.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26591146.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c26591146.filter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	if g:GetDefense()<=0 then
		op=Duel.SelectOption(tp,aux.Stringid(26591146,0))
	elseif g:GetAttack()<=0 then
		op=Duel.SelectOption(tp,aux.Stringid(26591146,1))+1
	else
		op=Duel.SelectOption(tp,aux.Stringid(26591146,0),aux.Stringid(26591146,1))
	end
	e:SetLabel(op)
end
function c26591146.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local op=e:GetLabel()
	local boost=0
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if op==0 then
			boost=tc:GetDefense()/2
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(boost)
			tc:RegisterEffect(e1)
		else
			boost=tc:GetAttack()/2
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(boost)
			tc:RegisterEffect(e1)
		end
	end
end
--inflict damage
function c26591146.drytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function c26591146.dryop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local atk=tc:GetTextAttack()/2
		if atk<0 then atk=0 end
		Duel.Damage(tp,atk,REASON_EFFECT)
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end