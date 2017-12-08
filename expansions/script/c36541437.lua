--Engraved Armament - Iware
--Script by XGlitchy30
function c36541437.initial_effect(c)
	--reveal trigger
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(36541437,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCountLimit(1)
	e1:SetCondition(c36541437.negcon)
	e1:SetCost(c36541437.negcost)
	e1:SetTarget(c36541437.negtg)
	e1:SetOperation(c36541437.negop)
	c:RegisterEffect(e1)
	--kaim special condition
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(36541437,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCountLimit(1)
	e2:SetCondition(c36541437.knegcon)
	e2:SetCost(c36541437.negcost)
	e2:SetTarget(c36541437.knegtg)
	e2:SetOperation(c36541437.knegop)
	c:RegisterEffect(e2)
end
--put here the codes of cards (in your possession) that would make you reveal a card
c36541437.reveals={
[770365]=true;
[2266498]=true;	 		                                                              																
[2295831]=true;		  	                                                             	 															
[2403771]=true;		  		      	     														
[5037726]=true;	    	                         	         															
[5373478]=true;		  	                                       	     															
[5489987]=true; 		     	                                                                          	 	 														
[5556668]=true;			             																
[5817857]=true; 		  	                                                        	        	     		      												
[7165085]=true;		                                                            																
[9076207]=true; 		 	                             	  															
[9576193]=true;		                                              																
[10060427]=true; 		  	                                                            	        	     		        												
[10441498]=true;     	                                                                      	 	 														 
[11082056]=true;	  																	
[11596936]=true;	 	                																
[12197543]=true;		  		  	         														
[12215894]=true;   	 	                          	      	     														
[12435193]=true;	  	                                    	        	     														
[13582837]=true;											
[13857930]=true; 		                                        																
[13997673]=true;		                  															
[14198496]=true;		 	                             	 															
[14309486]=true;		                                                      	        	  	  													
[14618326]=true;		 	                             	  															
[14733538]=true;		 	                                              	 	 														
[16435215]=true;		                          																
[17141718]=true;		                                                                	 															
[17194258]=true;		                                                                       	 	 	 	 	 	 	 	 	 	 	 
[17330916]=true;			   	 														
[17720747]=true;		                                     	 															
[17732278]=true;		                      																
[18658572]=true;		                        	 	  	    													
[19024706]=true;		                                       																
[19642889]=true; 		                                                               	        	      														
[20584712]=true;												
[22047978]=true;		                            	      															
[22479888]=true;		                                     																
[22842126]=true;		                                            																
[27340877]=true;		       															
[27995943]=true;		                                               	          	      	      													
[29146185]=true;		              	 															
[30126992]=true;		                              	  	      	      													
[30270176]=true;		                                                              																
[30435145]=true;		                               	   	    														
[30915572]=true;		                                     	         															
[30936186]=true;		                                         	        	     		 												
[31102447]=true;		                                                          	 		  													
[32314730]=true;		                                                	        	     														
[32360466]=true;		    	                                                                																
[33609262]=true;		                             	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 
[33900648]=true;		                                                                               	        															
[34124316]=true;		                                                      																
[34236961]=true;																	
[34545235]=true;		      												
[34694160]=true;		                    				
[35199656]=true;		                                         	 															
[35762283]=true;		               	 															
[36565699]=true;		                             																
[37955049]=true;		                                      	 															
[38167722]=true;		              	  															
[38517737]=true;		                                                                   																
[39037517]=true;		                                             	        	     		  												
[39238953]=true;			  	 														
[40213117]=true;		                    	 															
[40230018]=true;		                                                            																
[41091257]=true;		                                                                        	  	 														
[41201555]=true;		                                              	        	     		  												
[41224658]=true;		 	                           		    														
[41493640]=true;		                                                         		           														
[42444868]=true;		                                         	    															
[43262273]=true;		                        																
[43378076]=true; 		   	   														
[44663232]=true;		                               																
[45041488]=true;		                                                    	        	     		               												
[45450218]=true;		                                 	 	   														
[46089249]=true; 		                  																
[46232525]=true;																		
[46337945]=true;		                 																
[46833854]=true;		                                    	       															
[47120245]=true;			      															
[47222536]=true;		                                                                                    	   															
[49477180]=true;			 	  	  													
[49680980]=true;		                                                     	        	     		               												
[50527144]=true;		                           																
[51916032]=true;		                                                                             																
[52263685]=true;		        															
[52628687]=true;		                                                            																
[53039326]=true;		                                             	     	    														
[54520292]=true;		                                              	        	      														
[56611470]=true;		                                                          																
[56673480]=true;		                                                   																
[56827051]=true;		                                                                   	 	  	 	 												
[56981417]=true;		                                           																
[57319935]=true;		                                                                         	      															
[57734012]=true;		                                                   
[58165765]=true;		                                                             	  	    	    													
[58604027]=true;		                                                                                 	    															
[58753372]=true;		                                                                	 	     														
[58990631]=true;		                        																
[59432181]=true;		                                 																
[59546528]=true;		                                            	  															
[61807040]=true;		 															
[62015408]=true;		                                                           																
[64280356]=true;		                                                                  	       	           														
[64990807]=true;		                          																
[66127916]=true;		                                   	       															
[66399675]=true;		                                             	  	       														
[66690411]=true;		      																
[66729231]=true;		                                     	 															
[66816282]=true;		                                                     	        	     		               												
[67237709]=true;		      	    														
[67547370]=true;		                                                                                         																
[68809475]=true;		                                                  	        	     		 			 	 			
[69584564]=true;		   															
[71044499]=true;		                                    																
[71203602]=true;		                                      	  															
[71703785]=true;		                                                  	 	   														
[71705144]=true;		                                    	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 
[72053645]=true;		                                      																
[72129804]=true;		  															
[72403299]=true;		                                 	  															
[73659078]=true;				     														
[73783043]=true;		                   	 															
[73988674]=true;																	
[74576482]=true;		                                                         	        	     		  												
[76751255]=true;		                                                 																
[79441381]=true;			 															
[80367387]=true;		                                            	        	     		 												
[80925836]=true;		                                         	        	     														
[81434470]=true;																	
[81866673]=true;		                                                                 	 	 														
[82016179]=true;		                                                       																
[83546647]=true;		                              																
[84613836]=true;		 															
[85239662]=true;		                                 	  															
[86585274]=true;		                                    	 															
[87102774]=true;		                                  																
[87148330]=true;		   	                      	 															
[88754763]=true;		   		
[88757791]=true;			 														
[89113320]=true;		   																	
[89312388]=true;		                                         	 															
[90434926]=true;		  	                          	  	  														
[90519313]=true;			                       																
[90616316]=true;		  	                                         	     	  														
[90887783]=true;		                         																
[93542102]=true;	 		 	 														
[94096018]=true;		 	                                                              	  	  														
[95090813]=true;		   	                                                                                  	        	     														
[95642274]=true;		  	           																
[97926515]=true;	  	                                        																
[98301564]=true;   	 																	
[99177923]=true;
[36541431]=true;
[36541432]=true;
[36541433]=true;
[36541434]=true;
[36541435]=true;
[36541436]=true;	
}
--filters
function c36541437.negfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c36541437.allow_tg(c)
	return c:GetFlagEffect(36541448)~=0
end
--values
function c36541437.chainlimit(e,ep,tp)
	return tp~=ep
end
--reveal trigger
function c36541437.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	return c36541437.reveals[re:GetHandler():GetCode()]
		and (c:IsLocation(LOCATION_MZONE) or (c:IsLocation(LOCATION_SZONE) and ec)) and not Duel.IsExistingMatchingCard(c36541437.allow_tg,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c36541437.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(36541437)<=0 end
	e:GetHandler():RegisterFlagEffect(36541437,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c36541437.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c36541437.negfilter(chkc) end
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if chk==0 then return Duel.IsExistingTarget(c36541437.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and (c:IsLocation(LOCATION_MZONE) or (c:IsLocation(LOCATION_SZONE) and ec)) end
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tspec=te:GetHandler()
		if tspec:IsSetCard(0xba43) then
			ng:AddCard(tspec)
		end
	end
	local neg=Duel.GetMatchingGroup(c36541437.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,neg,ng:GetCount(),0,0)
	Duel.SetChainLimit(c36541437.chainlimit)
end
function c36541437.negop(e,tp,eg,ep,ev,re,r,rp)
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tspec=te:GetHandler()
		if tspec:IsSetCard(0xba43) then
			ng:AddCard(tspec)
		end
	end
	if ng:GetCount()<=0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local neg=Duel.SelectTarget(tp,c36541437.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ng:GetCount(),nil)
	local nspec=neg:Filter(Card.IsRelateToEffect,nil,e)
	if nspec:GetCount()>0 then
		local ntc=nspec:GetFirst()
		while ntc do
			Duel.NegateRelatedChain(ntc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			ntc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			ntc:RegisterEffect(e2)
			ntc=nspec:GetNext()
		end
	end
end
--kaim special condition--
--runic trigger	
function c36541437.knegcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	return c36541437.reveals[re:GetHandler():GetCode()]
		and (c:IsLocation(LOCATION_MZONE) or (c:IsLocation(LOCATION_SZONE) and ec)) and Duel.IsExistingMatchingCard(c36541437.allow_tg,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end	
function c36541437.knegtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if chk==0 then return Duel.IsExistingMatchingCard(c36541437.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and (c:IsLocation(LOCATION_MZONE) or (c:IsLocation(LOCATION_SZONE) and ec)) end
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tspec=te:GetHandler()
		if tspec:IsSetCard(0xba43) then
			ng:AddCard(tspec)
		end
	end
	local neg=Duel.GetMatchingGroup(c36541437.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,neg,ng:GetCount(),0,0)
	Duel.SetChainLimit(c36541437.chainlimit)
end
function c36541437.knegop(e,tp,eg,ep,ev,re,r,rp)
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tspec=te:GetHandler()
		if tspec:IsSetCard(0xba43) then
			ng:AddCard(tspec)
		end
	end
	if ng:GetCount()<=0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local neg=Duel.SelectMatchingCard(tp,c36541437.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ng:GetCount(),nil)
	Duel.SetTargetCard(neg)
	if neg:GetCount()>0 then
		local ntc=neg:GetFirst()
		while ntc do
			Duel.NegateRelatedChain(ntc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			ntc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			ntc:RegisterEffect(e2)
			ntc=neg:GetNext()
		end
	end
end