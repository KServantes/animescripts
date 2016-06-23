--Oopsword
--  By Shad3

local self=c511005020

function self.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_CHAINING)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetCondition(self.cd)
  e1:SetTarget(self.tg)
  e1:SetOperation(self.op)
  c:RegisterEffect(e1)
end

function self.cd(e,tp,eg,ep,ev,re,r,rp)
  if rp==tp then return false end
  if not (re and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)) then return false end
  local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
  if not g or g:GetCount()~=1 then return false end
  return g:GetFirst():IsOnField()
end

function self.lv3_fil(c,e,tp)
  return c:GetLevel()==3 and c:IsRace(RACE_WARRIOR) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function self.tg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(self.lv3_fil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function self.op(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(self.lv3_fil,tp,LOCATION_GRAVE,0,nil,e,tp)
  if g:GetCount()==0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local sg=g:Select(tp,1,1,nil)
  Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
  Duel.ChangeTargetCard(ev,sg)
end