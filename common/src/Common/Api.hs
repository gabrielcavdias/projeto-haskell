{-# LANGUAGE DeriveGeneric #-}
{-# language DeriveAnyClass  #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module Common.Api where

import Data.Aeson
import Data.Text (Text)
import GHC.Generics (Generic)
import Database.PostgreSQL.Simple

-- Schema

data Card = Card {
    cardId :: Int,
    cardNome :: Text,
    cardCMC :: Int,
    cardQtd :: Int
} deriving (Generic, ToJSON, FromJSON, ToRow, FromRow, Eq, Show)

-- Content

p1 :: String
p1 = "A ideia para o Grimório Silvestre surgiu em uma conversa entre amigos sobre sua pequena mas crescente coleção de Magic. Você começa a jogar Magic e tudo que tem são algumas cartas aleatórias, aos poucos você monta seu primeiro deck, o segundo e quando percebe aquela caixa de sapato já não serve mais."

p2 :: String 
p2 = "O Grimório Silvestre oferece ao usuário formas de catalogar e organizar sua coleção, adicione as cartas que você tem, a qual coleção elas pertencem se estão em formato impecável ou com aquele arranhão que você deixou antes de começar a usar shield. Nunca mais fique em dúvida se você tem ou não aquele playset de raio foil para colocar no seu deck Burn Pauper. E falando de decks.."

p3 :: String 
p3 = "Em busca de montar novos decks, mas a grana tá meio curta? quem sabe você já não tem um tesouro escondido aí.. O Grimório Silvestre tem a solução pra você! Equipado com um bom algoritmo de comparação, nosso site é capaz de recomendar decks totalmente inesperados baseados no que você já tem bem aí na sua casa. Onde mais você teria a ideia de montar um commander 'tribal' de snipers?"

p4 :: String
p4 = "Passe para frente todas aquelas cartas que não te interessam mais adicionando-as à sua pasta de troca. use sua lista de desejos para marcar quais cartas você quer.. e descubra quem está passando elas! =)"

about :: String
about = "Site desenvolvido em Haskell e Obelisk pelos alunos:"

helio :: String
helio = "Helio Gabriel Cavalcante Dias - RA: 0050831921009"

lucca :: String
lucca = "Lucca Costa Santos - RA: 0050831921013"