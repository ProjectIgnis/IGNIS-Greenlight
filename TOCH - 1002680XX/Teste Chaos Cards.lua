--Created using senpaizuri's Puzzle Maker (updated by Naim & Larry126)
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN+DUEL_SIMPLE_AI,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)

--Main Deck
Debug.AddCard(100268008,0,0,LOCATION_DECK,0,POS_FACEDOWN)
Debug.AddCard(100268008,0,0,LOCATION_DECK,0,POS_FACEDOWN)
Debug.AddCard(69832741,0,0,LOCATION_DECK,0,POS_FACEDOWN)
Debug.AddCard(100268008,0,0,LOCATION_DECK,0,POS_FACEDOWN)
Debug.AddCard(14536035,0,0,LOCATION_DECK,0,POS_FACEDOWN)
Debug.AddCard(14536035,0,0,LOCATION_DECK,0,POS_FACEDOWN)
Debug.AddCard(100268007,0,0,LOCATION_DECK,0,POS_FACEDOWN)
Debug.AddCard(21844576,0,0,LOCATION_DECK,0,POS_FACEDOWN)
Debug.AddCard(21844576,0,0,LOCATION_DECK,0,POS_FACEDOWN)
Debug.AddCard(75878039,0,0,LOCATION_DECK,0,POS_FACEDOWN)
Debug.AddCard(75878039,0,0,LOCATION_DECK,0,POS_FACEDOWN)
--Hand
Debug.AddCard(5758500,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(100268007,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(69832741,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(100268006,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(19230407,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(83764718,0,0,LOCATION_HAND,0,POS_FACEDOWN)
Debug.AddCard(100268008,0,0,LOCATION_HAND,0,POS_FACEDOWN)
--GY
Debug.AddCard(75878039,0,0,LOCATION_GRAVE,0,POS_FACEUP)
Debug.AddCard(100268007,0,0,LOCATION_GRAVE,0,POS_FACEUP)
Debug.AddCard(75878039,0,0,LOCATION_GRAVE,0,POS_FACEUP)
Debug.AddCard(75878039,0,0,LOCATION_GRAVE,0,POS_FACEUP)
Debug.AddCard(85991529,0,0,LOCATION_GRAVE,0,POS_FACEUP)
Debug.AddCard(100268006,0,0,LOCATION_GRAVE,0,POS_FACEUP)
Debug.AddCard(85991529,0,0,LOCATION_GRAVE,0,POS_FACEUP)
Debug.AddCard(100268008,0,0,LOCATION_GRAVE,0,POS_FACEUP)
Debug.AddCard(85991529,0,0,LOCATION_GRAVE,0,POS_FACEUP)
Debug.AddCard(100268008,0,0,LOCATION_GRAVE,0,POS_FACEUP)
Debug.AddCard(100268008,0,0,LOCATION_GRAVE,0,POS_FACEUP)
Debug.AddCard(100268008,0,0,LOCATION_GRAVE,0,POS_FACEUP)
--Monster Zones
Debug.AddCard(75878039,0,0,LOCATION_MZONE,0,1,true)
Debug.AddCard(14536035,0,0,LOCATION_MZONE,1,1,true)
Debug.AddCard(21844576,0,0,LOCATION_MZONE,2,1,true)
--Spell & Trap Zones
Debug.AddCard(82999629,0,0,LOCATION_SZONE,5,10)
Debug.AddCard(100268009,0,0,LOCATION_SZONE,2,10)
--Spell & Trap Zones
Debug.AddCard(50913601,1,1,LOCATION_SZONE,5,10)
Debug.AddCard(62279055,1,1,LOCATION_SZONE,3,10)
Debug.ReloadFieldEnd()