{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications, ScopedTypeVariables #-}

module Home where

import Control.Monad
import qualified Data.Text as T
import Language.Javascript.JSaddle (eval, liftJSM)
import Reflex.Dom.Core
import Common.Api

home :: ( DomBuilder t m
         , Prerender js t m
          ) => m ()
home = do
  prerender_ blank $ liftJSM $ void $ eval ("window.localStorage.getItem('alert') ? '' : window.alert('Bem vindo ao meu primeiro site em Obelisk =)'); window.localStorage.setItem('alert', '1')" :: T.Text)

  elAttr "main" ("class" =: "container home") $ do
        elAttr "div" ("class" =: "innerContainer") $ do
          elAttr "span" ("class" =: "text-detail text-detail--red") $ do
            text "Esse site é uma versão reduzida do projeto desenvolvida para as aulas de Haskell, "
            elAttr "a" ("href" =: "https://grimorio-silvestre.herokuapp.com" <> "target" =: "_blank") $ text "confira a versão completa"
        elAttr "h1" ("class" =: "title") $ text "Bem vindo ao Grimório Silvestre"
        el "p" $ text $ T.pack p1
        el "h2" $ text $ "Tá na hora de organizar!"
        el "p" $ text $ T.pack p2
        el "h2" $ text $ "Recomendações personalizadas!"
        elAttr "div" ("class" =: "flex") $ do
          elAttr "img" ("src" =: "https://c1.scryfall.com/file/scryfall-cards/large/front/0/3/039d25d4-ce26-4ecf-bbf5-42187cf0230a.jpg?1591234267") blank
          el "p" $ text $ T.pack p3
        el "h2" $ text $ "Vamos trocar alguns cards?"
        el "p" $ text $ T.pack p4
        elAttr "span" ("class" =: "text-detail") $ text "E não se preocupe, lhe ajudaremos a achar as peças que faltam para o seu tribal de sniper.."