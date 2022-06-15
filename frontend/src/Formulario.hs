{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications, ScopedTypeVariables #-}

module Formulario where

import qualified Data.Text as T
import Obelisk.Route
import Reflex.Dom.Core
import Data.Maybe
import Text.Read
import Common.Api
import Common.Route
import Data.Aeson

form:: ( DomBuilder t m
           , Prerender js t m
           ) => m ()
form = do
  elAttr "main" ("class" =: "container formulario") $ do
    elAttr "h1" ("class" =: "title") $ text "Adicionar cartas à coleção"
    elAttr "label" ("class" =: "label-title") (text "Card:") 
    nome <- inputElement def
    elAttr "label" ("class" =: "label-title") (text "CMC:") 
    cmc <- numberInput
    elAttr "label" ("class" =: "label-title") (text "Quantidade:") 
    qtd <- numberInput
    -- MV = Mana value que é o mesmo que CMC, renomeado para evitar shadow binding
    let card = fmap (\((n, mv),q) -> Card 0 n mv q) (zipDyn (zipDyn (_inputElement_value nome) cmc) qtd)
    (submitBtn, _) <- el' "button" (text "Adicionar à coleção")
    let click = domEvent Click submitBtn
    let cardEvt = tag (current card) click
    _ :: Dynamic t (Event t (Maybe T.Text)) <- prerender
        (pure never)
        (fmap decodeXhrResponse <$> performRequestAsync (sendData (BackendRoute_AddCard :/ ()) <$> cardEvt))
    return ()

numberInput :: (DomBuilder t m, Num a, Read a) => m (Dynamic t a)
numberInput = do
      n <- inputElement $ def
        & inputElementConfig_initialValue .~ "0"
        & inputElementConfig_elementConfig . elementConfig_initialAttributes .~ ("type" =: "number") 
      return $ fmap (fromMaybe 0 . readMaybe . T.unpack) (_inputElement_value n)

sendData :: ToJSON a => R BackendRoute -> a -> XhrRequest T.Text
sendData r dados = postJson (getRoute r) dados

getRoute :: R BackendRoute -> T.Text
getRoute r = renderBackendRoute checFullREnc r