--Ashfallen Prowler
--Reference cards: Salamangreat Foxy, Orcustrated Einsatz, any BA malebranche, evenly matched, pankratops
--Grave Squirmer, Salamagreat Spinny, Shaddols, Alviss of th Nordic Alfar, Triggering Wurm
--Destiny hero diamond dude
--Dark armed dragon (probably just for incandis)
--SPYRAL double helix
function c17000200.initial_effect(c)
   --SS from hand
   local e1=Effect.CreateEffect(c)
   e1:SetDescription(aux.Stringid(17000200,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,17000200)
	e1:SetCondition(c17000200.sscon)
	e1:SetTarget(c17000200.sstg)
	e1:SetOperation(c17000200.ssop)
	c:RegisterEffect(e1)
	--excavate
	local e2=Effect.CreateEffect(c)
   e2:SetDescription(aux.Stringid(17000200,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,17000201)
	e2:SetTarget(c17000200.target)
	e2:SetOperation(c17000200.tgybop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
   c:RegisterEffect(e3)
	--banished
	local e4=Effect.CreateEffect(c)
   e4:SetDescription(aux.Stringid(17000200,2))
   e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
   e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
   e4:SetCode(EVENT_REMOVE)
   e4:SetCountLimit(1,17000202)
   e4:SetCondition(c17000200.bancon)
   e4:SetTarget(c17000200.bantg)
   e4:SetOperation(c17000200.banop)
   c:RegisterEffect(e4)
end
--SS condition (you control fewer monsters than there are FIRE monsters in GY)
function c17000200.sscon(e,c,tp)
   if c==nil then return true end
   local ct=Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_FIRE)
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and ct>Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,nil)
end
function c17000200.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then --return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c17000200.ssop(e,tp,eg,ep,ev,re,r,rp)
   if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
   end
end
--Excavate
function c17000200.thfilter(c, e, tp)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToGrave() and c:IsAbleToRemove()
end
function c17000200.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE+CATEGORY_REMOVE,nil,1,0,LOCATION_DECK)
end
function c17000200.tgybop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,3)
	local g=Duel.GetDecktopGroup(p,3)
	if g:GetCount()>0 and g:IsExists(c17000200.thfilter,1,nil) and Duel.SelectYesNo(p,aux.Stringid(17000200,1)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_OPERATECARD)
      local sg=g:FilterSelect(p,c17000200.thfilter,1,1,nil)
      local tc=sg:GetFirst()
      if tc and tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
         Duel.SendtoGrave(tc,REASON_EFFECT)
      else
         Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
      end
	end
	Duel.ShuffleDeck(p)
end
--banished
function c17000200.banfilter(c, e, tp)
   return c:IsSetCard(0x318) and c:IsType(TYPE_MONSTER)
end
function c17000200.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c17000200.banfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c17000200.bancon(e,tp,eg,ep,ev,re,r,rp)
   return e:GetHandler():IsReason(REASON_EFFECT) and re:GetHandler():IsSetCard(0x318)
end
function c17000200.banop(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17000200.banfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
      Duel.Damage(1-tp,300,REASON_EFFECT)
	end
end