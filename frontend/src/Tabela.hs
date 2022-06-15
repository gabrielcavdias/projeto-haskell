{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications, ScopedTypeVariables #-}

module Tabela where

import Control.Monad.Fix
import qualified Data.Text as T
import Obelisk.Route
import Reflex.Dom.Core
import Common.Api
import Common.Route

getRoute :: R BackendRoute -> T.Text
getRoute r = renderBackendRoute checFullREnc r

getCards :: XhrRequest ()
getCards = xhrRequest "GET" (getRoute (BackendRoute_GetCards :/ ())) def

tableData :: DomBuilder t m => Card -> m ()
tableData pr = do 
    el "tr" $ do
        el "td" (text $ T.pack $ show $ cardId pr)
        el "td" (text $ cardNome pr)
        el "td" (text $ T.pack $ show $ cardQtd pr)
        el "td" (text $ T.pack $ show $ cardCMC pr)

table :: ( DomBuilder t m
            , Prerender js t m
            , MonadHold t m
            , MonadFix m
            , PostBuild t m) => m ()
table = do
    elAttr "main" ("class" =: "container tabela") $ do
      elAttr "h1" ("class" =: "title") $ text "Minha coleção"
      elAttr "div" ("class" =: "innerContainer") $ do
        (btn, _) <- el' "button" (text "Atualizar")
        let click = domEvent Click btn
        home :: Dynamic t (Event t (Maybe [Card])) <- prerender
          (pure never)
          (fmap decodeXhrResponse <$> performRequestAsync (const getCards <$> click))
        dynP <- foldDyn (\ps d -> case ps of
                            Nothing -> []
                            Just p -> d++p) [] (switchDyn home)
        elAttr "div" ("class" =: "tableContainer") $ do                            
          el "table" $ do
            el "thead" $ do
              el "tr" $ do
                el "th" $ text "Id"
                el "th" $ text "Nome"
                el "th" $ text "Qtd"
                el "th" $ text "CMC"

            el "tbody" $ do
              dyn_ (fmap sequence (ffor dynP (fmap tableData)))
